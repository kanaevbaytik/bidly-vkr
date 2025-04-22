//
//  CategoriesView.swift
//  Bidly
//
//  Created by Baytik on 8/3/25.
//

import UIKit

class CategoriesView: UIView {
    private let categories: [(image: UIImage?, title: String)] = [
        (UIImage(named: "electronic"), "Электроника"),
        (UIImage(named: "auto"), "Авто"),
        (UIImage(named: "forChildren"), "Для детей"),
        (UIImage(named: "sport"), "Спорт"),
        (UIImage(named: "dom"), "Дом"),
        (UIImage(named: "mebel"), "Мебель"),
        (UIImage(named: "redkoe"), "Редкое"),
        (UIImage(named: "drugoe"), "Другое")
    ]
    
    private let topStackView = UIStackView()
    private let bottomStackView = UIStackView()
    private let mainStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 32
        addSubview(mainStackView)
        
        [topStackView, bottomStackView].forEach { stack in
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.spacing = 12
            mainStackView.addArrangedSubview(stack)
        }
        
        for (index, category) in categories.enumerated() {
            let view = createCategoryView(image: category.image, title: category.title)
            if index < 4 {
                topStackView.addArrangedSubview(view)
            } else {
                bottomStackView.addArrangedSubview(view)
            }
        }
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36)
        ])
    }
    
    private func createCategoryView(image: UIImage?, title: String) -> UIView {
        let container = UIView()
        let imageView = UIImageView(image: image)
        let label = UILabel()
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.backgroundColor = UIColor.systemBlue
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(imageView)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.heightAnchor.constraint(equalToConstant: 48),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }
}
