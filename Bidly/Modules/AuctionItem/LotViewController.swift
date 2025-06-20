//
//  AuctionItemViewController.swift
//  Bidly
//
//  Created by Baytik  on 14/3/25.
//

import UIKit

class LotViewController: UIViewController {
    
//    private let auctionItem: AuctionItem
    private let auctionItem: AuctionItem
    
    private let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabelBar: UILabel = {
        let label = UILabel()
        label.text = "Товар"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private let sellerInfoView = SellerInfoView()
    
    private let imageCarouselView: LotImageCarouselView = {
        let view = LotImageCarouselView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let bidLabel = UILabel()
    private let endtimeLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let bidButton = CustomButton(title: "Сделать ставку", isActive: true)
    
    init(auctionItem: AuctionItem) {
        self.auctionItem = auctionItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupScrollView()
        setupViews()
        configureData()
    }
    
    private func setupNavigationBar() {
        title = "Товар"

        var shareConfig = UIButton.Configuration.plain()
        shareConfig.image = UIImage(systemName: "square.and.arrow.up")
        shareConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        let shareButton = UIButton(configuration: shareConfig)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)

        var likeConfig = UIButton.Configuration.plain()
        likeConfig.image = UIImage(systemName: "heart")
        likeConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        let likeButton = UIButton(configuration: likeConfig)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)

        var moreConfig = UIButton.Configuration.plain()
        moreConfig.image = UIImage(systemName: "ellipsis")
        moreConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        let moreButton = UIButton(configuration: moreConfig)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: moreButton),
            UIBarButtonItem(customView: likeButton),
            UIBarButtonItem(customView: shareButton)
        ]
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
        bidButton.isEnabled = true
        bidButton.addTarget(self, action: #selector(bidButtonTapped), for: .touchUpInside)
            
        contentStackView.addArrangedSubview(imageCarouselView)
        imageCarouselView.heightAnchor.constraint(equalToConstant: 380).isActive = true // 300 + 60 + spacing
        
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
        categoryLabel.text = auctionItem.category.rawValue
        bidLabel.text = "Текущая ставка: \(auctionItem.lastBid) сом"
        sellerInfoView.configure(name: auctionItem.sellerName)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        endtimeLabel.text = "Завершение: \(formatter.string(from: auctionItem.endDate))"
        
        descriptionLabel.text = "Описание: \(auctionItem.description)"
        
        // Устанавливаем изображения для карусели
//        imageCarouselView.imageUrls = auctionItem.imageNames
        imageCarouselView.imageUrls = auctionItem.itemImages.map { $0.imageUrl }

    }
    
    @objc private func shareTapped() {
        print("Share tapped")
    }

    @objc private func likeTapped() {
        print("Like tapped")
    }

    @objc private func moreTapped() {
        print("More tapped")
    }
    
    @objc private func bidButtonTapped() {
        let dialog = BidDialogViewController(currentBid: auctionItem.lastBid, minStep: Int(Double(auctionItem.startPrice) * 0.05))
        dialog.onConfirm = { [weak self] newBid in
            print("Ставка подтверждена: \(newBid) сом")
            // тут ты можешь отправить ставку на сервер или обновить UI
        }
        present(dialog, animated: true)
    }
}
