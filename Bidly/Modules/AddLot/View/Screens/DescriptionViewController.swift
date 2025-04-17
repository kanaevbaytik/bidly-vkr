//
//  DescriptionViewController.swift
//  Bidly
//
//  Created by Baytik on 17/3/25.
//

import UIKit

class DescriptionViewController: UIViewController {

    weak var delegate: LotStepDelegate?
    private let viewModel: CreateLotViewModel

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        textView.text = "Введите описание"
        textView.textColor = .lightGray
        return textView
    }()

    private let nextButton = CustomButton(title: "Далее")

    var isFormValid: Bool {
        return descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
               descriptionTextView.text != "Введите описание"
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
        navigationItem.title = "Описание товара"

        descriptionTextView.delegate = self
        view.addSubview(descriptionTextView)
        view.addSubview(nextButton)

        setupConstraints()
        setupActions()
        addDoneButtonToTextView()

        nextButton.updateState(isEnabled: false)
    }

    private func setupConstraints() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


    private func setupActions() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func nextButtonTapped() {
        let trimmedText = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if viewModel.setDescription(trimmedText) {
            delegate?.goToNextPage()
            print("описание отправлено!")
        }
    }
    private func addDoneButtonToTextView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        descriptionTextView.inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() {
        descriptionTextView.resignFirstResponder()
    }

}

// MARK: - UITextViewDelegate

extension DescriptionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        nextButton.updateState(isEnabled: isFormValid)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Введите описание" {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Введите описание"
            textView.textColor = .lightGray
            nextButton.updateState(isEnabled: false)
        }
    }
}
