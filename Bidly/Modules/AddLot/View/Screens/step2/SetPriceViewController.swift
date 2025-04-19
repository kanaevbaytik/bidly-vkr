//
//  SetPriceViewController.swift
//  Bidly
//
//  Created by Baytik  on 10/3/25.
//

import UIKit

class SetPriceViewController: UIViewController {
    weak var delegate: LotStepDelegate?
    private let viewModel: CreateLotViewModel

    private let priceField = CustomTextField(placeholder: "Введите минимальную цену")
    private let stepField = CustomTextField(placeholder: "Минимальный шаг"/*, isEnabled: false*/)
    private let nextButton = CustomButton(title: "Далее")

    var isFormValid: Bool {
        return !(priceField.text?.isEmpty ?? true)
    }

    init(viewModel: CreateLotViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Указать цену"

        let priceContainer = CustomTextFieldContainer(textFields: [
            (priceField, "Минимальная цена")
        ])

        let stepContainer = CustomTextFieldContainer(textFields: [
            (stepField, "Минимальный шаг ставки")
        ])

        view.addSubview(priceContainer)
        view.addSubview(stepContainer)
        view.addSubview(nextButton)

        setupConstraints(priceContainer, stepContainer)

        priceField.addTarget(self, action: #selector(priceChanged), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        priceField.keyboardType = .numberPad

        nextButton.isEnabled = false
        nextButton.alpha = 0.5
    }

    private func setupConstraints(_ priceContainer: UIView, _ stepContainer: UIView) {
        priceContainer.translatesAutoresizingMaskIntoConstraints = false
        stepContainer.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
           
            priceContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            priceContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),

            stepContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stepContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stepContainer.topAnchor.constraint(equalTo: priceContainer.bottomAnchor, constant: 20),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func priceChanged() {
        guard let text = priceField.text, let price = Double(text) else {
            stepField.text = ""
            nextButton.updateState(isEnabled: false)
            return
        }
        
        let step = calculateStep(minPrice: price)
        stepField.text = "\(step) KGS"

        nextButton.updateState(isEnabled: isFormValid)
    }

    private func calculateStep(minPrice: Double) -> Double {
        return (minPrice * 0.05).rounded()
    }

    @objc private func nextButtonTapped() {
        guard
            let priceText = priceField.text,
            let price = Double(priceText),
            isFormValid
        else {
            return
        }

        let success = viewModel.setPricing(startPrice: price)

        if success {
            delegate?.goToNextPage()
        }
    }
}
