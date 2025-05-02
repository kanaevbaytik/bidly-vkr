//
//  AuctionItemCell.swift
//  Bidly
//
//  Created by Baytik  on 12/3/25.
//

import UIKit

class AuctionItemCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let bidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = false
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 6
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        
        contentView.addSubviews(imageView, titleLabel, categoryLabel, bidLabel, dateLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        bidLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            bidLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            bidLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            dateLabel.topAnchor.constraint(equalTo: bidLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: AuctionItem, dateFormatter: DateFormatter) {
        if let firstImageName = item.imageNames.first {
            imageView.image = UIImage(named: firstImageName)
        } else {
            imageView.image = nil
        }
        titleLabel.text = item.title
        categoryLabel.text = item.category.rawValue
        bidLabel.text = "\(item.lastBid) KGS"
        dateLabel.text = dateFormatter.string(from: item.endDate)
    }
}


