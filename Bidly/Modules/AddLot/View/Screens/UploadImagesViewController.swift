//
//  UploadImagesViewController.swift
//  Bidly
//
//  Created by Baytik  on 17/3/25.
//

import UIKit


class UploadImagesViewController: UIViewController {
    
    weak var delegate: LotStepDelegate?
    private let viewModel: CreateLotViewModel

    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить фото", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        return button
    }()
       private var uploadedPhotos: [UIImage] = []
       private let nextButton = CustomButton(title: "Далее")

       private lazy var uploadedPhotosContainer = UploadedPhotosContainer()

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
        navigationItem.title = "Загрузка фото"

        let uploadPhotoContainer = UploadPhotoContainer(button: addPhotoButton)

        view.addSubview(uploadPhotoContainer)
        view.addSubview(uploadedPhotosContainer)
        view.addSubview(nextButton)

        setupConstraints(uploadPhotoContainer, uploadedPhotosContainer)

        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        nextButton.isEnabled = false
        nextButton.alpha = 0.5
    }


    private func setupConstraints(_ uploadPhotoContainer: UIView, _ uploadedPhotosContainer: UIView) {
        uploadPhotoContainer.translatesAutoresizingMaskIntoConstraints = false
        uploadedPhotosContainer.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            uploadPhotoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            uploadPhotoContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadPhotoContainer.widthAnchor.constraint(equalToConstant: 349),
            uploadPhotoContainer.heightAnchor.constraint(equalToConstant: 194),

            uploadedPhotosContainer.topAnchor.constraint(equalTo: uploadPhotoContainer.bottomAnchor, constant: 20),
            uploadedPhotosContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadedPhotosContainer.widthAnchor.constraint(equalToConstant: 349),
            uploadedPhotosContainer.heightAnchor.constraint(equalToConstant: 137),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


    @objc private func addPhotoTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }

    private func updateNextButtonState() {
        nextButton.updateState(isEnabled: !uploadedPhotos.isEmpty)
    }

    @objc private func nextButtonTapped() {
        if !uploadedPhotos.isEmpty {
            let success = viewModel.setImages(uploadedPhotos)
            if success {
                delegate?.goToNextPage()
            }
        }
    }
}

extension UploadImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            uploadedPhotos.append(image)
            uploadedPhotosContainer.addPhoto(image)
            updateNextButtonState()
        }
    }
}

