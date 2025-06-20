//
//  ImageCell.swift
//  Bidly
//
//  Created by Baytik  on 22/4/25.
//
//import UIKit
//
//class ImageCell: UICollectionViewCell {
//    
//    static let identifier = "ImageCell"
//    private let imageView = UIImageView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.addSubview(imageView)
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(with image: UIImage?) {
//        imageView.image = image
//    }
//}



import UIKit
import Kingfisher

final class ImageCell: UICollectionViewCell {
    
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withUrl urlString: String) {
        guard let url = URL(string: urlString) else { return }
        imageView.kf.setImage(with: url)
    }
}
