//
//  SuccessViewController.swift
//  Bidly
//
//  Created by Baytik on 25/3/25.
//

import UIKit

class SuccessViewController: UIViewController, SuccessContainerViewDelegate {
    
    weak var delegate: LotStepDelegate?
    private let viewModel: CreateLotViewModel

    private lazy var successContainer: SuccessContainerView = {
        let view = SuccessContainerView()
        view.delegate = self
        return view
    }()

    init(viewModel: CreateLotViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Успешно!"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true

        print("viewDidLoad вызван")
        setupUI()
        setupPublishAction()
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

    private func setupPublishAction() {
        successContainer.publishAction = { [weak self] in
            self?.publishLot()
        }
    }
    
    // MARK: - SuccessContainerViewDelegate
    private func publishLot() {
        print("Попытка опубликовать лот...")

        viewModel.publishLot { [weak self] success in
            DispatchQueue.main.async {
                switch success {
                case .success:
                    print("Лот успешно опубликован")
                    let alert = UIAlertController(title: "Успешно", message: "Лот опубликован!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default))
                    self?.present(alert, animated: true)

                case .failure(let error):
                    print("Ошибка при публикации лота: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось опубликовать лот.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Понял", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    func didTapPublish() {
        print("🔄 Публикуем лот...")

        // Пример данных — потом ты их получишь из ViewModel или input
        let title = "iPhone 12"
        let price = 100.0

        LotService.shared.publishLot(title: title, price: price) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let alert = UIAlertController(title: "Успешно", message: "Лот опубликован!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default))
                    self?.present(alert, animated: true)
                case .failure(let error):
                    let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Понял!", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
    }


    func didTapBackToHome() {
        delegate?.finishCreatingLot()
        print("нажата кнопка вернутся домой")
    }
}
