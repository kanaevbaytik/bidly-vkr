//
//  SuccessViewController.swift
//  Bidly
//
//  Created by Baytik on 25/3/25.
//

import UIKit

class SuccessViewController: UIViewController, SuccessContainerViewDelegate {
    func submitLot() {
        //
    }
    
    func fetchTestPosts() {
        //
    }
    
    
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
            self?.didTapPublish()
        }
    }
    
    
    func didTapPublish() {
        print("🔄 Публикуем лот...")

        if let lotToSave = viewModel.toStorageModel() {
            LotStorageService.save(lotToSave)
            print("✅ Лот сохранён локально")
        }



        LotService.shared.publishLot(viewModel: viewModel) { [weak self] result in
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
    // моковые функции для теста!
//    func fetchTestPosts() {
//        APIService.shared.request(endpoint: "/posts", method: .GET) { (result: Result<[Post], APIError>) in
//            switch result {
//            case .success(let posts):
//                print("✅ Успешно получили посты:")
//                for post in posts.prefix(5) {
//                    print("📝 ID: \(post.id) — \(post.title)")
//                }
//            case .failure(let error):
//                print("❌ Ошибка: \(error)")
//            }
//        }
//    }
//
//    
//    func submitLot() {
//        guard let requestModel = viewModel.toCreateRequest() else {
//            print("❌ Invalid lot data")
//            return
//        }
//
//        guard let jsonData = try? JSONEncoder().encode(requestModel) else {
//            print("❌ Failed to encode lot")
//            return
//        }
//
//        APIService.shared.request(
//            endpoint: "/lots", // Уточни потом у напарника путь
//            method: .POST,
//            body: jsonData
//        ) { (result: Result<ServerResponseModel, APIError>) in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    print("✅ Lot created: \(response)")
//                case .failure(let error):
//                    print("❌ Error: \(error)")
//                }
//            }
//        }
//    }

    
    func didTapBackToHome() {
        delegate?.finishCreatingLot()
        print("нажата кнопка вернутся домой")
    }
}
