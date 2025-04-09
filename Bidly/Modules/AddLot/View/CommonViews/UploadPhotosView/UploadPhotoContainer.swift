//
//  UploadPhotoContainer.swift
//  Bidly
//
//  Created by Baytik  on 24/3/25.
//

import UIKit

class UploadPhotoContainer: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Добавить фото"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    init(button: UIButton) {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        layer.cornerRadius = 12

        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8

        addSubview(label)
        addSubview(button)

        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),

            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
