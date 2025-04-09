//  SuccessViewController.swift
//  Bidly
//
//  Created by Baytik  on 25/3/25.
//

import UIKit

class SuccessViewController: UIViewController, SuccessContainerViewDelegate {
    
    weak var delegate: LotStepDelegate?

    
    private lazy var successContainer: SuccessContainerView = {
        let view = SuccessContainerView()
        view.delegate = self // Делегат гарантированно устанавливается сразу при создании
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Успешно!"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        print("viewDidLoad вызван")
        print("Кнопка видна? \(successContainer.isHidden == false)")
        print("Кнопка доступна? \(successContainer.isUserInteractionEnabled)")
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(successContainer)
        successContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            successContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            successContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            successContainer.heightAnchor.constraint(equalToConstant: 260)
        ])
    }

    // MARK: - SuccessContainerViewDelegate
    func didTapBackToHome() {
        delegate?.finishCreatingLot()
        print("нажата кнопка вернутся домой")
    }
}
