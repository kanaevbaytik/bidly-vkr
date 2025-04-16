//
//  SellerInfoView.swift
//  Bidly
//
//  Created by Baytik  on 16/4/25.
//

import UIKit

class SellerInfoView: UIView {
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle")
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Продавец"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "bubble.left.and.bubble.right.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(avatarImageView)
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(UIView()) // для гибкости, чтобы messageButton справа
        
        addSubview(stack)
        addSubview(messageButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            messageButton.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            messageButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(name: String, image: UIImage? = nil) {
        nameLabel.text = name
        if let img = image {
            avatarImageView.image = img
        }
    }
}
