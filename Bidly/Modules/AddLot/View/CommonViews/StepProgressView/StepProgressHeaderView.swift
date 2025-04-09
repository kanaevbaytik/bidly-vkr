//
//  StepProgressHeaderView.swift
//  Bidly
//
//  Created by Baytik  on 24/3/25.
//

import UIKit

class StepProgressHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private let stepProgressView: StepProgressView
        
    init(title: String, steps: Int) {
        self.stepProgressView = StepProgressView(steps: steps)
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 120))
        
        backgroundColor = UIColor(hex: "#FCFCFCFF")
        titleLabel.text = title
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubviews(stepProgressView, titleLabel)
        
        stepProgressView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stepProgressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            stepProgressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stepProgressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22),
            stepProgressView.widthAnchor.constraint(equalToConstant: 280),
            stepProgressView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    func setCurrentStep(_ step: Int) {
            stepProgressView.setCurrentStep(step)
        }
    
    
}

