//
//  AuctionItemViewController.swift
//  Bidly
//
//  Created by Baytik  on 14/3/25.
//

import UIKit

class LotViewController: UIViewController {
    
    private let auctionItem: AuctionItem
    
    init(auctionItem: AuctionItem) {
        self.auctionItem = auctionItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageCarousel: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 300, height: 200)
            layout.minimumLineSpacing = 10
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
            return collectionView
        }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let endtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bidButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("make bid", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        configureData()

    }
    private func setupViews(){
        view.addSubviews(imageCarousel, titleLabel, categoryLabel, bidLabel, endtimeLabel, bidButton)
        NSLayoutConstraint.activate([
            imageCarousel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageCarousel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageCarousel.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: imageCarousel.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            bidLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            bidLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            endtimeLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            endtimeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            bidButton.topAnchor.constraint(equalTo: endtimeLabel.bottomAnchor, constant: 20),
            bidButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bidButton.widthAnchor.constraint(equalToConstant: 200),
            bidButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureData() {
        titleLabel.text = auctionItem.title
        categoryLabel.text = auctionItem.category
        bidLabel.text = "current bid: \(auctionItem.lastBid)"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        endtimeLabel.text = "end time: \(formatter.string(from: auctionItem.endDate))"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}
