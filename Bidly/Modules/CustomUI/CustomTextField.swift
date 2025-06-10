//
//  CustomTextField.swift
//  Bidly
//
//  Created by Baytik  on 3/3/25.
//
//import UIKit
//
//class CustomTextField: UITextField {
//    private var gradientLayer: CAGradientLayer?
//    let originalPlaceholder: String
//
//    init(placeholder: String) {
//        self.originalPlaceholder = placeholder
//        super.init(frame: .zero)
//        setupTextField()
//        setupToolbar()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupTextField() {
//        borderStyle = .none
//        layer.cornerRadius = 12
//        backgroundColor = .clear
//        
//        
//        
//        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
//        leftViewMode = .always
//        
//        self.attributedPlaceholder = NSAttributedString(
//            string: originalPlaceholder,
//            attributes: [
//                .foregroundColor: UIColor.black.withAlphaComponent(0.3)
//            ]
//        )
//        
//        gradientLayer = CAGradientLayer()
//        gradientLayer?.colors = [
//            UIColor(hex: "#EDEBFAFF")!.cgColor,
//            UIColor(hex: "#F8F7FFFF")!.cgColor
//        ]
//        gradientLayer?.locations = [0, 1]
//        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 1.0)
//        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 0.0)
//        gradientLayer?.cornerRadius = 10
//        
//        if let gradientLayer = gradientLayer {
//            layer.insertSublayer(gradientLayer, at: 0)
//        }
//    }
//    private func setupToolbar() {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
//        
//        toolbar.setItems([flexibleSpace, doneButton], animated: false)
//        self.inputAccessoryView = toolbar
//    }
//    
//    @objc private func doneButtonTapped() {
//        self.resignFirstResponder()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        gradientLayer?.frame = bounds
//    }
//}
import UIKit

class CustomTextField: UITextField {
    private var gradientLayer: CAGradientLayer?
    let originalPlaceholder: String
    
    private let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 40)
    private let borderLayer = CAShapeLayer()
    private let animationDuration = 0.3
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    private var isPasswordVisible = false
    
    init(placeholder: String, isSecure: Bool = false) {
        self.originalPlaceholder = placeholder
        super.init(frame: .zero)
        self.isSecureTextEntry = isSecure
        
        setupTextField()
        setupToolbar()
        if isSecure {
            addPasswordToggle()
        }
        
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        borderStyle = .none
        layer.cornerRadius = 12
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Настройка анимированного бордера
        borderLayer.lineWidth = 1.5
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.clear.cgColor
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.addSublayer(borderLayer)
        
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
    
    @objc private func editingDidBegin() {
        animateBorder(color: UIColor(hex: "#56549EFF")!, width: 1.5)
    }
    
    @objc private func editingDidEnd() {
        animateBorder(color: .clear, width: 0)
    }
    
    private func animateBorder(color: UIColor, width: CGFloat) {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = borderLayer.path
        pathAnimation.toValue = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.fromValue = borderLayer.strokeColor
        colorAnimation.toValue = color.cgColor
        
        let widthAnimation = CABasicAnimation(keyPath: "lineWidth")
        widthAnimation.fromValue = borderLayer.lineWidth
        widthAnimation.toValue = width
        
        let group = CAAnimationGroup()
        group.animations = [pathAnimation, colorAnimation, widthAnimation]
        group.duration = animationDuration
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        borderLayer.add(group, forKey: "borderAnimation")
        
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = width
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        self.inputAccessoryView = toolbar
    }
    
    private func addPasswordToggle() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        toggleButton.frame = container.bounds
        container.addSubview(toggleButton)
        rightView = container
        rightViewMode = .always
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        if let existingText = text, isFirstResponder {
            deleteBackward()
            insertText(existingText + " ")
            deleteBackward()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    @objc private func doneButtonTapped() {
        self.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    func showError(message: String) {
        let errorAnimation = CABasicAnimation(keyPath: "strokeColor")
        errorAnimation.fromValue = borderLayer.strokeColor
        errorAnimation.toValue = UIColor.systemRed.cgColor
        errorAnimation.duration = 0.3
        
        borderLayer.add(errorAnimation, forKey: "errorBorderAnimation")
        borderLayer.strokeColor = UIColor.systemRed.cgColor
        borderLayer.lineWidth = 1.5
    }
    
    func hideError() {
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.fromValue = borderLayer.lineWidth
        animation.toValue = 0
        animation.duration = 0.3
        borderLayer.add(animation, forKey: "hideErrorAnimation")
        
        borderLayer.lineWidth = 0
    }
}
