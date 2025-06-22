//
//  BidDialogViewController.swift
//  Bidly
//
//  Created by Baytik  on 24/4/25.
//

import UIKit

class BidDialogViewController: UIViewController {
    
    private let currentBid: Int
    private let minStep: Int
    private var selectedBid: Int {
        didSet {
            selectedBidLabel.text = "\(selectedBid) сом"
        }
    }
    
    // MARK: - UI
    private let containerView = UIView()
    private let currentBidLabel = UILabel()
    private let minStepLabel = UILabel()
    private let selectedBidLabel = UILabel()
    private let infoLabel = UILabel()
    private let decreaseButton = UIButton(type: .system)
    private let increaseButton = UIButton(type: .system)
    private let confirmButton = CustomButton(title: "Cделать ставку", isActive: true)
    
    var onConfirm: ((Int) -> Void)?

    private let auctionItemId: String

    init(currentBid: Int, minStep: Int, auctionItemId: String) {
        self.currentBid = currentBid
        self.minStep = minStep
        self.auctionItemId = auctionItemId
        self.selectedBid = currentBid + minStep
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateDecreaseButtonState()
        containerView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)

    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        let bidStack = UIStackView(arrangedSubviews: [currentBidLabel, minStepLabel])
        bidStack.axis = .vertical
        bidStack.spacing = 8
        
        let stepperStack = UIStackView(arrangedSubviews: [decreaseButton, selectedBidLabel, increaseButton])
        stepperStack.axis = .horizontal
        stepperStack.spacing = 16
        stepperStack.alignment = .center
        stepperStack.distribution = .equalSpacing
        
        let mainStack = UIStackView(arrangedSubviews: [bidStack, stepperStack, infoLabel, confirmButton])
        mainStack.axis = .vertical
        mainStack.spacing = 24
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        // Current bid label
        currentBidLabel.text = "Текущая ставка: \(currentBid) сом"
        currentBidLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        // Min step label
        minStepLabel.text = "Минимальный шаг: \(minStep) сом"
        minStepLabel.font = .systemFont(ofSize: 16)
        minStepLabel.textColor = .gray
        
        // Selected bid label
        selectedBidLabel.text = "\(selectedBid) сом"
        selectedBidLabel.font = .boldSystemFont(ofSize: 24)
        selectedBidLabel.textAlignment = .center
        selectedBidLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Decrease button
        // В методе setupUI() замените настройки кнопок на:

        // Decrease button
        // Decrease button
        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        decreaseButton.setTitleColor(UIColor(hex: "#5856D6FF"), for: .normal) // Синий знак
        decreaseButton.setTitleColor(.systemGray, for: .disabled)
        decreaseButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        decreaseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        decreaseButton.layer.cornerRadius = 22
        decreaseButton.layer.borderColor = UIColor(hex: "#56549EFF")?.cgColor // Фиолетовая обводка
        decreaseButton.layer.borderWidth = 2
        decreaseButton.backgroundColor = .white // Белый фон
        decreaseButton.layer.shadowColor = UIColor.black.cgColor // Тень
        decreaseButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        decreaseButton.layer.shadowRadius = 4
        decreaseButton.layer.shadowOpacity = 0.15
        decreaseButton.addTarget(self, action: #selector(decreaseBid), for: .touchUpInside)

        // Increase button
        increaseButton.setTitle("+", for: .normal)
        increaseButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        increaseButton.setTitleColor(UIColor(hex: "#5856D6FF"), for: .normal) // Синий знак
        increaseButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        increaseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        increaseButton.layer.cornerRadius = 22
        increaseButton.layer.borderColor = UIColor(hex: "#56549EFF")?.cgColor // Фиолетовая обводка
        increaseButton.layer.borderWidth = 2
        increaseButton.backgroundColor = .white // Белый фон
        increaseButton.layer.shadowColor = UIColor.black.cgColor // Тень
        increaseButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        increaseButton.layer.shadowRadius = 4
        increaseButton.layer.shadowOpacity = 0.15
        increaseButton.addTarget(self, action: #selector(increaseBid), for: .touchUpInside)
        
        // Info label
        infoLabel.text = "Ваша максимальная ставка сохранится, даже если вас перебьют"
        infoLabel.font = .systemFont(ofSize: 14)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.textColor = .darkGray
        
        // Confirm button
//        confirmButton.setTitle("Сделать ставку", for: .normal)
//        confirmButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
//        confirmButton.backgroundColor = .systemBlue
//        confirmButton.setTitleColor(.white, for: .normal)
//        confirmButton.layer.cornerRadius = 10
//        confirmButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTappedOutside))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateDecreaseButtonState() {
        let canDecrease = selectedBid > currentBid + minStep
        decreaseButton.isEnabled = canDecrease
        decreaseButton.layer.borderColor = canDecrease ? UIColor(hex: "#56549EFF")?.cgColor : UIColor.systemGray.cgColor
        decreaseButton.setTitleColor(canDecrease ? UIColor(hex: "#5856D6FF") : .systemGray, for: .normal)
        
        // Обновляем тень для активного состояния
        UIView.animate(withDuration: 0.2) {
            self.decreaseButton.layer.shadowOpacity = canDecrease ? 0.15 : 0
        }
    }
    
    @objc private func decreaseBid() {
        let newBid = selectedBid - minStep
        if newBid >= currentBid + minStep {
            selectedBid = newBid
            updateDecreaseButtonState()
        }
    }

    @objc private func increaseBid() {
        selectedBid += minStep
        updateDecreaseButtonState()
    }
    
    @objc private func confirmTapped() {
        confirmButton.isEnabled = false

        BidService.shared.placeBid(amount: selectedBid, auctionItemId: auctionItemId) { [weak self] result in
            DispatchQueue.main.async {
                self?.confirmButton.isEnabled = true

                switch result {
                case .success:
                    print("✅ Ставка успешно отправлена")
                    self?.dismiss(animated: true)
                case .failure(let error):
                    print("❌ Ошибка при отправке ставки: \(error.localizedDescription)")
                    self?.showErrorAlert()
                }
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось отправить ставку. Попробуйте позже.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }


    
    @objc private func dismissTappedOutside() {
        dismiss(animated: true)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                containerView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 100 {
                dismiss(animated: true)
            } else {
                // Возвращаем обратно, если свайп был незначительный
                UIView.animate(withDuration: 0.3) {
                    self.containerView.transform = .identity
                }
            }
        default:
            break
        }
    }
}
