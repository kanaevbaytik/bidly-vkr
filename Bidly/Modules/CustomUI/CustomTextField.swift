//
//  CustomTextField.swift
//  Bidly
//
//  Created by Baytik  on 3/3/25.
//
import UIKit

class CustomTextField: UITextField {
    private var gradientLayer: CAGradientLayer?
    let originalPlaceholder: String

    init(placeholder: String) {
        self.originalPlaceholder = placeholder
        super.init(frame: .zero)
        setupTextField()
        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        borderStyle = .none
        layer.cornerRadius = 12
        backgroundColor = .clear
        
        
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        leftViewMode = .always
        
        self.attributedPlaceholder = NSAttributedString(
            string: originalPlaceholder,
            attributes: [
                .foregroundColor: UIColor.black.withAlphaComponent(0.3)
            ]
        )
        
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [
            UIColor(hex: "#EDEBFAFF")!.cgColor,
            UIColor(hex: "#F8F7FFFF")!.cgColor
        ]
        gradientLayer?.locations = [0, 1]
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer?.cornerRadius = 10
        
        if let gradientLayer = gradientLayer {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        self.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        self.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer?.frame = bounds
    }
}
