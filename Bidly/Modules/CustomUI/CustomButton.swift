//
//  CustomButton.swift
//  Bidly
//
//  Created by Baytik  on 3/3/25.
//

import UIKit

class CustomButton: UIButton {
    init(title: String, isActive: Bool = false) {
        super.init(frame: .zero)
        setupButton(title: title)
        updateState(isEnabled: isActive)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .disabled)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 12
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        heightAnchor.constraint(equalToConstant: 50).isActive = true // Фиксированная высота
    }

    func updateState(isEnabled: Bool) {
        self.isEnabled = isEnabled
        UIView.animate(withDuration: 0.2) {
            self.alpha = isEnabled ? 1.0 : 0.7
            self.backgroundColor = isEnabled ? UIColor(hex: "#56549EFF") : UIColor.systemGray4
        }
    }
    
    private var originalTitle: String?
    private var activityIndicator: UIActivityIndicatorView?
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            originalTitle = title(for: .normal)
            setTitle("", for: .normal)
            
            if activityIndicator == nil {
                let indicator = UIActivityIndicatorView(style: .medium)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                addSubview(indicator)
                NSLayoutConstraint.activate([
                    indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                    indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
                activityIndicator = indicator
            }
            
            activityIndicator?.startAnimating()
            isEnabled = false
        } else {
            setTitle(originalTitle, for: .normal)
            activityIndicator?.stopAnimating()
            isEnabled = true
        }
    }
}

