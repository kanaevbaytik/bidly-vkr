//
//  NotificationCell.swift
//  Bidly
//
//  Created by Baytik  on 20/4/25.
//
import UIKit

final class NotificationCell: UITableViewCell {
    
    static let identifier = "NotificationCell"

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "bell.fill"))
        imageView.tintColor = .white
        imageView.backgroundColor = .systemIndigo
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubviews(avatarImageView, iconImageView, titleLabel, subtitleLabel, dotView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),

            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),

            dotView.widthAnchor.constraint(equalToConstant: 10),
            dotView.heightAnchor.constraint(equalToConstant: 10),
            dotView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            dotView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
        ])
    }

    func configure(with item: NotificationItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        dotView.isHidden = !item.isNew

        if item.type == .bidPlaced {
            containerView.backgroundColor = UIColor(hex: "#EDEBFAFF")
            
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOpacity = 0.4
            containerView.layer.shadowRadius = 3
            containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            containerView.layer.masksToBounds = false
            containerView.layer.shouldRasterize = true
            containerView.layer.rasterizationScale = UIScreen.main.scale
                
        } else {
            containerView.backgroundColor = .white
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOpacity = 0.2
            containerView.layer.shadowRadius = 0
            containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            containerView.layer.masksToBounds = false
            containerView.layer.shouldRasterize = true
            containerView.layer.rasterizationScale = UIScreen.main.scale

        }

        if let avatar = item.avatarImage {
            avatarImageView.image = avatar
            avatarImageView.isHidden = false
            iconImageView.isHidden = true
        } else {
            iconImageView.isHidden = false
            avatarImageView.isHidden = true
        }
    }
}
