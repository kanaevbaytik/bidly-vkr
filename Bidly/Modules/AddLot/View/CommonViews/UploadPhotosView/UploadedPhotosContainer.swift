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
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true

        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.addTarget(self, action: #selector(removePhoto(_:)), for: .touchUpInside)

        let photoView = UIStackView(arrangedSubviews: [imageView, deleteButton])
        photoView.spacing = 4
        stackView.addArrangedSubview(photoView)
    }

    @objc private func removePhoto(_ sender: UIButton) {
        guard let photoView = sender.superview else { return }
        stackView.removeArrangedSubview(photoView)
        photoView.removeFromSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
