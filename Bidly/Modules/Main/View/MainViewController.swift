import UIKit

class MainViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let refreshControl = UIRefreshControl()

    private let contentView = UIView()

    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return button
    }()

    private let newsCarousel = NewsCarouselView()

    private let categoriesView = CategoriesView()

    private let popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Популярное"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private var auctionItems: [AuctionItem] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        }
    }

    // Моковые данные для тестирования
//    private let mockAuctionItems: [AuctionItem] = [
//        AuctionItem(
//            imageName: "example1",
//            title: "iPhone 13 Pro 256GB",
//            category: .electronics,
//            startPrice: 65000,
//            lastBid: 72000,
//            endDate: Date().addingTimeInterval(86400 * 3), // Через 3 дня
//            description: "Отличное состояние, батарея 98%, полная комплектация",
//            sellerName: "Иван Иванов",
//            imageNames: ["example1", "example1","example2","example3" ]
//        ),
//        AuctionItem(
//            imageName: "mock1",
//            title: "MacBook Air M1, 2020, 256/8 GB, 13.3 inch, space gray",
//            category: .electronics,
//            startPrice: 450000,
//            lastBid: 480000,
//            endDate: Date().addingTimeInterval(86400 * 5), // Через 5 дней
//            description: "Макбук Эйр, стильный, современный, циклов заряда: 122, объяем памяти 256 ГБ, ОЗУ 8 ГБ",
//            sellerName: "Алексей Петров",
//            imageNames: ["mock1", "mock2","mock3", "mock4","mock5"]
//        ),
//        AuctionItem(
//            imageName: "mock_painting",
//            title: "Картина маслом 'Море'",
//            category: .electronics,
//            startPrice: 25000,
//            lastBid: 32000,
//            endDate: Date().addingTimeInterval(86400 * 2), // Через 2 дня
//            description: "Авторская работа, размер 60х40 см, 2022 год",
//            sellerName: "Галерея 'Арт-Сфера'",
//            imageNames: ["mock_painting"]
//        ),
//        AuctionItem(
//            imageName: "mock_car",
//            title: "Toyota Camry 2018",
//            category: .auto,
//            startPrice: 1500000,
//            lastBid: 1550000,
//            endDate: Date().addingTimeInterval(86400 * 7), // Через 7 дней
//            description: "Пробег 45000 км, один хозяин, полная сервисная история",
//            sellerName: "Дмитрий Смирнов",
//            imageNames: ["mock_car_1", "mock_car_2", "mock_car_3"]
//        )
//    ]

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AuctionItemCell.self, forCellWithReuseIdentifier: "AuctionItemCell")

        categoriesView.onCategorySelected = { [weak self] selectedCategory in
            let vc = CategoryAuctionsViewController(category: selectedCategory)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        // Настройка pull-to-refresh
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl

        Task {
            await fetchPopularLots()
        }
    }


    private var collectionViewHeightConstraint: NSLayoutConstraint!

    private func setupUI() {
        navigationItem.title = "Главная"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(newsCarousel, categoriesView, popularLabel, collectionView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        newsCarousel.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        popularLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 300)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            newsCarousel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            newsCarousel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            newsCarousel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            newsCarousel.heightAnchor.constraint(equalToConstant: 132),

            categoriesView.topAnchor.constraint(equalTo: newsCarousel.bottomAnchor, constant: 26),
            categoriesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            categoriesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            popularLabel.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 26),
            popularLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            collectionView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            collectionViewHeightConstraint
        ])
    }

    private func fetchPopularLots() async {
        defer {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }

        do {
            let responses = try await AuctionAPI.shared.fetchPopularLots()
            self.auctionItems = responses.map {
                AuctionItem(
                    imageName: $0.itemImages.first?.imageUrl ?? "",
                    title: $0.title,
                    category: .electronics,
                    startPrice: Int($0.startingPrice),
                    lastBid: Int($0.currentPrice),
                    endDate: $0.endTime,
                    description: $0.description,
                    sellerName: "Продавец",
                    itemImages: $0.itemImages
                )
            }
        } catch {
            print("Ошибка загрузки лотов: \(error)")
        }
    }

    @objc private func refreshData() {
        Task {
            await fetchPopularLots()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }

}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return auctionItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuctionItemCell", for: indexPath) as! AuctionItemCell
        let item = auctionItems[indexPath.item]
        cell.configure(with: item, dateFormatter: dateFormatter)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = auctionItems[indexPath.item]
        let vc = LotViewController(auctionItem: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}
