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
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        for i in 0..<steps {
            let circleView = UIView()
            circleView.layer.cornerRadius = 12
            circleView.layer.borderWidth = 2
            circleView.layer.borderColor = UIColor.gray.cgColor
            circleView.backgroundColor = .white
            circleView.translatesAutoresizingMaskIntoConstraints = false
            
            let stepLabel = UILabel()
            stepLabel.text = "\(i + 1)"
            stepLabel.textAlignment = .center
            stepLabel.font = .systemFont(ofSize: 14, weight: .medium)
            
            circleView.addSubview(stepLabel)
            stepLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stepLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
                stepLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
            ])
            
            circleView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            circleView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            stepCircles.append(circleView)
            stackView.addArrangedSubview(circleView)
            
            // Добавляем линию только если это не последний шаг
            if i < steps - 1 {
                let lineView = UIView()
                lineView.backgroundColor = .gray
                stepLines.append(lineView)
                stackView.addArrangedSubview(lineView)
                
                lineView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    lineView.heightAnchor.constraint(equalToConstant: 2),
                    lineView.widthAnchor.constraint(equalToConstant: 24)
                ])
            }
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        updateSteps()
    }


    
    private func updateSteps() {
        for (index, circle) in stepCircles.enumerated() {
            if index < currentStep {
                circle.backgroundColor = .purple
                circle.layer.borderColor = UIColor.purple.cgColor
            } else {
                circle.backgroundColor = .white
                circle.layer.borderColor = UIColor.gray.cgColor
            }
        }
        
        for (index, line) in stepLines.enumerated() {
            line.backgroundColor = index < currentStep - 1 ? .purple : .gray
        }
    }
    
    func setCurrentStep(_ step: Int) {
        guard step > 0 && step <= steps else { return }
        currentStep = step
    }
}
