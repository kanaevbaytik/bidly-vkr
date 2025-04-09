//
//  CustomButton.swift
//  Bidly
//
//  Created by Baytik  on 3/3/25.
//

import UIKit

class CustomButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
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
        updateState(isEnabled: false) // Начальное состояние — неактивное
    }

    func updateState(isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.alpha = isEnabled ? 1.0 : 0.5
        self.backgroundColor = isEnabled ? UIColor.systemBlue : UIColor.lightGray
    }
}
//nextButton.setTitle("Далее", for: .normal)
//nextButton.backgroundColor = .lightGray
//nextButton.setTitleColor(.white, for: .disabled)
//nextButton.setTitleColor(.black, for: .normal)
//nextButton.layer.cornerRadius = 8
//nextButton.isEnabled = false
//nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
