//
//  CustomTextFieldContainer.swift
//  Bidly
//
//  Created by Baytik  on 20/3/25.
//


import UIKit

class CustomTextFieldContainer: UIView {
    
    private var textFields: [(CustomTextField, String)] // Теперь массив из кортежей
    private var stackView: UIStackView!

    init(textFields: [(CustomTextField, String)]) { // Принимаем (текстовое поле, тайтл)
        self.textFields = textFields
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        for (textField, title) in textFields { // Теперь кортеж распаковываем
            let fieldContainer = createFieldContainer(for: textField, title: title)
            stackView.addArrangedSubview(fieldContainer)
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func createFieldContainer(for textField: CustomTextField, title: String) -> UIView {
        let container = UIView()
        
        let label = UILabel()
        label.text = title // Теперь передаем название тайтла явно
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        container.addSubview(textField)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        return container
    }
}
