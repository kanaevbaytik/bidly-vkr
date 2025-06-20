//
//  ThumbnailCell.swift
//  Bidly
//
//  Created by Baytik  on 22/4/25.
//
import UIKit

final class ThumbnailCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 2 : 0
            layer.borderColor = isSelected ? UIColor.systemPurple.cgColor : nil
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
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
    
//    func configure(with image: UIImage?, isSelected: Bool) {
//        imageView.image = image
//        self.isSelected = isSelected
//    }
    func configure(withUrl urlString: String, isSelected: Bool) {
        guard let url = URL(string: urlString) else { return }
        imageView.kf.setImage(with: url)
        layer.borderWidth = isSelected ? 2 : 0
        layer.borderColor = isSelected ? UIColor.purple.cgColor : nil
    }

}
