//
//  UploadedPhotosContainer.swift
//  Bidly
//
//  Created by Baytik  on 24/3/25.
//

import UIKit

class UploadedPhotosContainer: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Загруженные фото"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        layer.cornerRadius = 12

        addSubview(label)
        addSubview(stackView)

        label.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),

            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    func addPhoto(_ image: UIImage) {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(removePhoto(_:)), for: .touchUpInside)

        containerView.addSubview(imageView)
        containerView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 64),

            deleteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -5),
            deleteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),

            containerView.widthAnchor.constraint(equalToConstant: 64),
            containerView.heightAnchor.constraint(equalToConstant: 64)
        ])

        containerView.setContentHuggingPriority(.required, for: .horizontal)
        containerView.setContentCompressionResistancePriority(.required, for: .horizontal)

        stackView.addArrangedSubview(containerView)
    }





    @objc private func removePhoto(_ sender: UIButton) {
        guard let containerView = sender.superview else { return }
        stackView.removeArrangedSubview(containerView)
        containerView.removeFromSuperview()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
