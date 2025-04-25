//
//  AuctionBannerView.swift
//  Bidly
//
//  Created by Baytik  on 25/4/25.
//
import UIKit

class AuctionBannerView: UIView {

    private let contentView = UIView()

    private let bannerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rulesIcon") ?? UIImage(systemName: "questionmark.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Правила аукциона"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Перед тем как начать, ознакомьтесь с условиями участия."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 0
        return label
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hex: "#AEA1E5FF")!.cgColor,
            UIColor(hex: "#56549EFF")!.cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Тень на внешнем представлении (self)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.cornerRadius = 12
        layer.masksToBounds = false // 👈 обязательно false, чтобы тень была видна

        // Контент
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.insertSublayer(gradientLayer, at: 0)

        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupLayout()
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
        gradientLayer.cornerRadius = contentView.layer.cornerRadius
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubviews(bannerIcon, titleLabel, subtitleLabel)

        bannerIcon.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bannerIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bannerIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bannerIcon.widthAnchor.constraint(equalToConstant: 50),
            bannerIcon.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: bannerIcon.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: bannerIcon.trailingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
