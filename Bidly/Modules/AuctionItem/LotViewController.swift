//
//  AuctionItemViewController.swift
//  Bidly
//
//  Created by Baytik  on 14/3/25.
//

import UIKit

class LotViewController: UIViewController {
    
    private let auctionItem: AuctionItem
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private let sellerInfoView = SellerInfoView()
    
    private let imageCarousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 200)
        layout.minimumLineSpacing = 10
                
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let bidLabel = UILabel()
    private let endtimeLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let bidButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сделать ставку", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    init(auctionItem: AuctionItem) {
        self.auctionItem = auctionItem
        super.init(nibName: nil, bundle: nil)
        imageCarousel.delegate = self
        imageCarousel.dataSource = self
        imageCarousel.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Товар"
        setupScrollView()
        setupViews()
        configureData()
    }
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    private func setupViews() {
        [titleLabel, categoryLabel, bidLabel, endtimeLabel, descriptionLabel].forEach {
            $0.numberOfLines = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabel.font = .boldSystemFont(ofSize: 24)
        categoryLabel.font = .systemFont(ofSize: 16)
        categoryLabel.textColor = .gray
        bidLabel.font = .boldSystemFont(ofSize: 20)
        endtimeLabel.font = .systemFont(ofSize: 16)
        endtimeLabel.textColor = .gray
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
            
        contentStackView.addArrangedSubview(imageCarousel)
        imageCarousel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(categoryLabel)
        contentStackView.addArrangedSubview(bidLabel)
        contentStackView.addArrangedSubview(endtimeLabel)
        contentStackView.addArrangedSubview(bidButton)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(sellerInfoView)
    }
    private func configureData() {
        titleLabel.text = auctionItem.title
        categoryLabel.text = auctionItem.category
        bidLabel.text = "Текущая ставка: \(auctionItem.lastBid) сом"
        sellerInfoView.configure(name: auctionItem.sellerName)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        endtimeLabel.text = "Завершение: \(formatter.string(from: auctionItem.endDate))"
        
        descriptionLabel.text = "Описание: \(auctionItem.description)"
    }
}

extension LotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return auctionItem.imageNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let image = UIImage(named: auctionItem.imageNames[indexPath.item])
        cell.configure(with: image)
        return cell
    }
}

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
