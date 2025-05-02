//
//  CategoriesView.swift
//  Bidly
//
//  Created by Baytik on 8/3/25.
//

import UIKit

class CategoriesView: UIView {
    
    var onCategorySelected: ((Category) -> Void)?
    
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
        
        for (index, category) in Category.allCases.enumerated() {
            let view = createCategoryView(for: category, at: index)
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
    
    private func createCategoryView(for category: Category, at index: Int) -> UIView {
        let container = UIView()
        container.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.tag = index
        
        let shadowContainer = UIView()
        shadowContainer.translatesAutoresizingMaskIntoConstraints = false
        shadowContainer.backgroundColor = .clear
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowContainer.layer.shadowRadius = 6
        shadowContainer.layer.shadowOpacity = 0.2
        shadowContainer.layer.cornerRadius = 12
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: category.imageName)?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.magnificationFilter = .nearest
        imageView.layer.minificationFilter = .trilinear
        imageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        shadowContainer.addSubview(imageView)
        
        let label = UILabel()
        label.text = category.rawValue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(shadowContainer)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            shadowContainer.widthAnchor.constraint(equalToConstant: 48),
            shadowContainer.heightAnchor.constraint(equalToConstant: 48),
            shadowContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            shadowContainer.topAnchor.constraint(equalTo: container.topAnchor),
            
            imageView.widthAnchor.constraint(equalTo: shadowContainer.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: shadowContainer.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: shadowContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: shadowContainer.centerYAnchor),
            
            label.topAnchor.constraint(equalTo: shadowContainer.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }
    
    @objc private func categoryTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else { return }
        let categories = Category.allCases
        guard categories.indices.contains(tappedView.tag) else { return }
        let selectedCategory = categories[tappedView.tag]
        onCategorySelected?(selectedCategory)
    }
}
