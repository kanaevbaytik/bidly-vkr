//
//  ProgressStepView.swift
//  Bidly
//
//  Created by Baytik  on 16/3/25.
//

import UIKit

class StepProgressView: UIView {
    
    private let steps: Int
    private var currentStep: Int = 1 {
        didSet { updateSteps() }
    }
    
    private var stepCircles: [UIView] = []
    private var stepLabels: [UILabel] = []
    private var stepLines: [UIView] = []
    
    init(steps: Int) {
        self.steps = steps
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 0 // Убираем промежутки между элементами
        
        for i in 0..<steps {
            // Создаем контейнер для круга с тенью
            let shadowContainer = UIView()
            shadowContainer.translatesAutoresizingMaskIntoConstraints = false
            
            // Настройка тени
            shadowContainer.layer.shadowColor = UIColor.black.cgColor
            shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
            shadowContainer.layer.shadowRadius = 2
            shadowContainer.layer.shadowOpacity = 0.2
            shadowContainer.layer.cornerRadius = 12
            
            // Круг шага
            let circleView = UIView()
            circleView.layer.cornerRadius = 12
            circleView.clipsToBounds = true
            circleView.translatesAutoresizingMaskIntoConstraints = false
            
            // Номер шага
            let stepLabel = UILabel()
            stepLabel.text = "\(i + 1)"
            stepLabel.textAlignment = .center
            stepLabel.font = .systemFont(ofSize: 14, weight: .medium)
            stepLabel.translatesAutoresizingMaskIntoConstraints = false
            
            circleView.addSubview(stepLabel)
            shadowContainer.addSubview(circleView)
            
            NSLayoutConstraint.activate([
                circleView.widthAnchor.constraint(equalToConstant: 24),
                circleView.heightAnchor.constraint(equalToConstant: 24),
                circleView.centerXAnchor.constraint(equalTo: shadowContainer.centerXAnchor),
                circleView.centerYAnchor.constraint(equalTo: shadowContainer.centerYAnchor),
                
                stepLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
                stepLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
            ])
            
            stepCircles.append(circleView)
            stepLabels.append(stepLabel)
            stackView.addArrangedSubview(shadowContainer)
            
            // Добавляем соединительную линию (кроме последнего шага)
            if i < steps - 1 {
                let lineView = UIView()
                lineView.backgroundColor = UIColor(hex: "#E5E5EAFF") // Светло-серый цвет
                lineView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    lineView.heightAnchor.constraint(equalToConstant: 1), // Тонкая линия
                    lineView.widthAnchor.constraint(equalToConstant: 24) // Фиксированная ширина
                ])
                
                stepLines.append(lineView)
                stackView.addArrangedSubview(lineView)
            }
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateSteps()
    }
    
    private func updateSteps() {
        for (index, circle) in stepCircles.enumerated() {
            let isActive = index < currentStep
            
            if isActive {
                circle.backgroundColor = UIColor(hex: "#56549EFF") // Фиолетовый
                stepLabels[index].textColor = .white // Белый текст для активного шага
            } else {
                circle.backgroundColor = UIColor(hex: "#E5E5EAFF") // Серый
                stepLabels[index].textColor = .darkGray // Темно-серый текст для неактивного
            }
        }
    }
    
    func setCurrentStep(_ step: Int) {
        guard step > 0 && step <= steps else { return }
        currentStep = step
    }
}
