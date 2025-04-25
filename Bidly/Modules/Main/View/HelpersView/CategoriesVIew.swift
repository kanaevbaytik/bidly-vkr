//
//  CategoriesView.swift
//  Bidly
//
//  Created by Baytik on 8/3/25.
//

import UIKit

class CategoriesView: UIView {
    // Исправлено: теперь кортеж содержит String для имени изображения
    private let categories: [(imageName: String, title: String)] = [
        ("electronic", "Электроника"),
        ("auto", "Авто"),
        ("forChildren", "Для детей"),
        ("sport", "Спорт"),
        ("dom", "Дом"),
        ("mebel", "Мебель"),
        ("redkoe", "Редкое"),
        ("drugoe", "Другое")
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
            // Передаем имя изображения (String), а не UIImage
            let view = createCategoryView(imageName: category.imageName, title: category.title)
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
    
    // Исправлено: теперь принимаем имя изображения (String)
    private func createCategoryView(imageName: String, title: String) -> UIView {
        let container = UIView()
        
        // Контейнер для тени
        let shadowContainer = UIView()
        shadowContainer.translatesAutoresizingMaskIntoConstraints = false
        shadowContainer.backgroundColor = .clear
        
        // Настройка тени
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowContainer.layer.shadowRadius = 6
        shadowContainer.layer.shadowOpacity = 0.2
        shadowContainer.layer.cornerRadius = 12
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.magnificationFilter = .nearest
        imageView.layer.minificationFilter = .trilinear
        imageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем imageView в контейнер для тени
        shadowContainer.addSubview(imageView)
        
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(shadowContainer)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            // Контейнер для тени
            shadowContainer.widthAnchor.constraint(equalToConstant: 48),
            shadowContainer.heightAnchor.constraint(equalToConstant: 48),
            shadowContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            shadowContainer.topAnchor.constraint(equalTo: container.topAnchor),
            
            // ImageView внутри контейнера
            imageView.widthAnchor.constraint(equalTo: shadowContainer.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: shadowContainer.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: shadowContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: shadowContainer.centerYAnchor),
            
            // Лейбл
            label.topAnchor.constraint(equalTo: shadowContainer.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }
}
