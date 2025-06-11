
import UIKit

class MainViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = UIView()

    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return button
    }()

    private let bannerView = AuctionBannerView()

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
        layout.itemSize = CGSize(width: 120, height: 150)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    private var auctionItems: [AuctionItem] = [
        AuctionItem(imageName: "example1", title: "iPhone 13", category: .electronics, startPrice: 25000, lastBid: 25000, endDate: Date(), description: """
lk;asdjfals;kjdf
askldjf;lsakdjfsd
als;djf;laskjdf
a;lskjdf;aslkdfj
""", sellerName: "jessy pinkman", imageNames: ["example1", "example2", "example3"]),
        AuctionItem(imageName: "mock1", title: "MacBook Air", category: .electronics, startPrice: 80000, lastBid: 80000, endDate: Date(), description: "Новый модель MacBook Air", sellerName: "walter white", imageNames: ["mock1", "mock2", "mock3", "mock4"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupBannerTapGesture()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AuctionItemCell.self, forCellWithReuseIdentifier: "AuctionItemCell")
        
        categoriesView.onCategorySelected = { [weak self] selectedCategory in
            let vc = CategoryAuctionsViewController(category: selectedCategory)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        Task {
            await fetchPopularLots()
        }
    
    }
    
    private func setupUI() {
        navigationItem.title = "Главная"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(bannerView, categoriesView, popularLabel, collectionView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        popularLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            bannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            bannerView.heightAnchor.constraint(equalToConstant: 132),
            
            categoriesView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 26),
            categoriesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            categoriesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            popularLabel.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 26),
            popularLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            collectionView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupBannerTapGesture() {
        bannerView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        bannerView.addGestureRecognizer(tapGesture)
    }

    @objc private func bannerTapped() {
        let rulesVC = RulesViewController()
        navigationController?.pushViewController(rulesVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return auctionItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuctionItemCell", for: indexPath) as! AuctionItemCell
        let item = auctionItems[indexPath.item]
        cell.configure(with: item, dateFormatter: dateFormatter)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 120)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = auctionItems[indexPath.item]
        let vc = LotViewController(auctionItem: item)
        navigationController?.pushViewController(vc, animated: true)
    }
    @MainActor
    private func fetchPopularLots() async {
        do {
            let responses = try await AuctionAPI.shared.fetchPopularLots()
            // Внутри AuctionAPI.fetchPopularLots()

            self.auctionItems = responses.map { response in
                AuctionItem(
                    imageName: response.itemImages.first?.imageUrl ?? "",
                    title: response.title,
                    category: .electronics, // пока category = null
                    startPrice: Int(response.startingPrice),
                    lastBid: Int(response.currentPrice),
                    endDate:  response.endTime,
                    description: response.description,
                    sellerName: "Продавец", // пока нет имени
                    imageNames: response.itemImages.map { $0.imageUrl }
                )
            }
            collectionView.reloadData()
        } catch {
            print("❌ Ошибка загрузки лотов: \(error)")
        }
    }
}

