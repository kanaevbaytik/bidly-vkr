//
//  MyBidsViewController.swift
//  Bidly
//MyBidsViewController
//  Created by Baytik  on 9/3/25.
//

import UIKit

class MyBidsViewController: UIViewController {
    
//MARK: -UI элементы
    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отправить лот", for: .normal)
        button.backgroundColor = UIColor.systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemPurple
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    //MARK: - жизенный цикл

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔧 viewDidLoad вызван")
        view.backgroundColor = .white
        layout()
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
    }

    //MARK: -Настройка UI

    private func layout() {
        print("🔧 layout настроен")
        view.addSubview(uploadButton)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            uploadButton.heightAnchor.constraint(equalToConstant: 50),
            uploadButton.widthAnchor.constraint(equalToConstant: 200),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 24)
        ])
    }
    //MARK: -Обработка события при нажатия на кнопку

    @objc private func uploadButtonTapped() {
        print("📤 Кнопка отправки нажата")
        activityIndicator.startAnimating()
        uploadButton.isEnabled = false

        print("📦 Подготовка данных для отправки...")
        // let image = UIImage(named: "example") // Пока не отправляем изображение
        let fakeImage = UIImage() // Отправим пустое изображение, т.к. API требует его

        print("📡 Начинается отправка запроса на сервер...")

        TestUploadService.shared.uploadLotWithImage(
            title: "Пример лота",
            category: "Одежда",
            startPrice: 15000,
            minBidStep: 500,
            image: fakeImage,
            imageFilename: "lot-test.jpeg"
        ) { result in
            DispatchQueue.main.async {
                print("📬 Ответ получен от сервера")
                self.activityIndicator.stopAnimating()
                self.uploadButton.isEnabled = true

                switch result {
                case .success(let response):
                    print("✅ Успешно: \(response)")
                    self.showAlert(title: "Успешно", message: "Лот отправлен!\nОтвет: \(response)")
                case .failure(let error):
                    print("❌ Ошибка: \(error.localizedDescription)")
                    self.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        print("🔔 Показывается alert: \(title)")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}

