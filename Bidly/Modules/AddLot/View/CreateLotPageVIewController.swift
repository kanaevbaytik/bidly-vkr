//
//  CreateLotPageViewController.swift
//  Bidly
//
//  Created by Baytik  on 17/3/25.
//

import UIKit

protocol LotStepDelegate: AnyObject {
    func goToNextPage()
    func goToPreviousPage()
    func finishCreatingLot()
}

class CreateLotPageViewController: UIPageViewController, LotStepDelegate {
    
    
    private var steps: [UIViewController] = []
    private var currentIndex = 0
    private let progressHeaderView = StepProgressHeaderView(title: "Создание лота", steps: 5)
    
    init(viewModel: CreateLotViewModel) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let enterLotVC = EnterLotDetailsViewController(viewModel: viewModel)
        let setPriceVC = SetPriceViewController(viewModel: viewModel)
        let uploadImagesVC = UploadImagesViewController(viewModel: viewModel)
        let descriptionVC = DescriptionViewController(viewModel: viewModel)
        let successVC = SuccessViewController(viewModel: viewModel)
        
        enterLotVC.delegate = self
        setPriceVC.delegate = self
        uploadImagesVC.delegate = self
        descriptionVC.delegate = self
        successVC.delegate = self
        
        steps = [enterLotVC, setPriceVC, uploadImagesVC, descriptionVC, successVC]
        
        if let firstVC = steps.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            updateNavigationTitle(for: firstVC)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupProgressHeaderView()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    private func setupProgressHeaderView() {
        view.addSubview(progressHeaderView)
        progressHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressHeaderView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func goToNextPage() {
        guard currentIndex < steps.count - 1 else { return }
        currentIndex += 1
        setViewControllers([steps[currentIndex]], direction: .forward, animated: true) { _ in
            self.updateNavigationTitle(for: self.steps[self.currentIndex])
            self.progressHeaderView.setCurrentStep(self.currentIndex + 1)
        }
    }
    
    func goToPreviousPage() {
        guard currentIndex > 0 else {
            if presentingViewController != nil {
                dismiss(animated: true, completion: nil)
            }
            return
        }
        currentIndex -= 1
        setViewControllers([steps[currentIndex]], direction: .reverse, animated: true) { _ in
            self.updateNavigationTitle(for: self.steps[self.currentIndex])
            self.progressHeaderView.setCurrentStep(self.currentIndex + 1)
        }
    }
    
    func finishCreatingLot() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateNavigationTitle(for viewController: UIViewController) {
        navigationItem.title = viewController.navigationItem.title
    }
    
    @objc private func backButtonTapped() {
        goToPreviousPage()
    }
}
