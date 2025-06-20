//
//  NewsCarouselCell.swift
//  Bidly
//
//  Created by Baytik  on 12/6/25.
//
import UIKit

class NewsCarouselCell: UICollectionViewCell {
    private let gradientLayer = CAGradientLayer()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        setupGradient()
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false
        backgroundColor = .clear
    }

    private func setupGradient() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerCurve = .continuous
        gradientLayer.cornerRadius = 25
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        contentView.layer.cornerRadius = 25
        contentView.layer.masksToBounds = true
    }

    private func setupViews() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = .white

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = .white
        arrowImageView.alpha = 0.8

        contentView.addSubviews(iconImageView, titleLabel, arrowImageView)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),

            arrowImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            arrowImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
        layer.shadowPath = UIBezierPath(roundedRect: contentView.frame, cornerRadius: 25).cgPath
    }

    func configure(icon: UIImage?, text: String, gradientColors: [CGColor]) {
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = text
        gradientLayer.colors = gradientColors
    }
}
