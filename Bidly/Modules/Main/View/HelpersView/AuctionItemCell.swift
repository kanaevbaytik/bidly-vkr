//
//  AuctionItemCell.swift
//  Bidly
//
//  Created by Baytik  on 12/3/25.
//

import UIKit
import Kingfisher

class AuctionItemCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.6)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 0
        button.clipsToBounds = true
        return button
    }()

    private let messageButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.6)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 0
        button.clipsToBounds = true
        return button
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
        
        contentView.addSubviews(imageView, titleLabel, categoryLabel, bidLabel, dateLabel, likeButton, messageButton)
        
        likeButton.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        
        [imageView, titleLabel, categoryLabel, bidLabel, dateLabel, likeButton, messageButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            
            messageButton.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 6),
            messageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            messageButton.widthAnchor.constraint(equalToConstant: 24),
            messageButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -8),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            bidLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            bidLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: bidLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: dateLabel.bottomAnchor, constant: 8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: AuctionItem, dateFormatter: DateFormatter) {
        titleLabel.text = item.title
//        categoryLabel.text = item.category
        bidLabel.text = "KGS \(Int(item.lastBid))"
        dateLabel.text = "до \(dateFormatter.string(from: item.endDate))"
        
        if let url = URL(string: item.imageName) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        }
    }
    
    
    @objc private func handleLikeTapped() {
        let isLiked = likeButton.currentImage == UIImage(systemName: "heart.fill")

        if isLiked {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }

        likeButton.tintColor = isLiked ? UIColor.systemRed.withAlphaComponent(0.7) : UIColor.systemRed

        // Простая анимация масштаба
        UIView.animate(withDuration: 0.15,
                       animations: {
                           self.likeButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                       }, completion: { _ in
                           UIView.animate(withDuration: 0.15) {
                               self.likeButton.transform = .identity
                           }
                       })
    }

}


