//
//  SuccessContainerView.swift
//  Bidly
//
//  Created by Baytik on 25/3/25.
//

import UIKit

protocol SuccessContainerViewDelegate: AnyObject {
    func didTapBackToHome()
    func didTapPublish()
    func submitLot() //снести потом
    func fetchTestPosts() // снести потом
}

class SuccessContainerView: UIView {

    weak var delegate: SuccessContainerViewDelegate?
    var publishAction: (() -> Void)? // Новый коллбэк

    private let successIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = UIColor(hex: "#56549EFF")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "Успешное создание лота"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private let backToHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Назад в главное", for: .normal)
        button.setTitleColor(UIColor(hex: "#5856D6FF"), for: .normal)
        button.backgroundColor = UIColor(hex: "#EDEBFAFF")
        button.layer.cornerRadius = 8
        return button
    }()

    private let publishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Опубликовать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#56549EFF")
        button.layer.cornerRadius = 8
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4

        let stackView = UIStackView(arrangedSubviews: [successIcon, successLabel, backToHomeButton, publishButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            successIcon.widthAnchor.constraint(equalToConstant: 48),
            successIcon.heightAnchor.constraint(equalToConstant: 48),
            backToHomeButton.widthAnchor.constraint(equalToConstant: 154),
            backToHomeButton.heightAnchor.constraint(equalToConstant: 42),
            publishButton.widthAnchor.constraint(equalToConstant: 154),
            publishButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func setupActions() {
        backToHomeButton.addTarget(self, action: #selector(backToHomeTapped), for: .touchUpInside)
        publishButton.addTarget(self, action: #selector(publishTapped), for: .touchUpInside)
    }

    @objc private func backToHomeTapped() {
        print("Кнопка нажата - backToHomeTapped")
        delegate?.didTapBackToHome()
    }

    
    @objc private func publishTapped() {
        print("Кнопка нажата - didTapPublish")
        delegate?.fetchTestPosts()
    }
}
