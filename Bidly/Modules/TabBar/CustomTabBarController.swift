import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let viewModel = CreateLotViewModel()
        
        let mainVC = UINavigationController(rootViewController: MainViewController())
        let myBidsVC = UINavigationController(rootViewController: MyBidsViewController())
        let addLotVC = UINavigationController(rootViewController: EnterLotDetailsViewController(viewModel: viewModel))
        let notificationsVC = UINavigationController(rootViewController: NotificationsViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        mainVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        myBidsVC.tabBarItem = UITabBarItem(title: "Bids", image: UIImage(systemName: "dollarsign.circle"), selectedImage: UIImage(systemName: "dollarsign.circle.fill"))
        addLotVC.tabBarItem = UITabBarItem(title: "", image: nil, selectedImage: nil)
        notificationsVC.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: "bell"), selectedImage: UIImage(systemName: "bell.fill"))
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.viewControllers = [mainVC, myBidsVC, addLotVC, notificationsVC, profileVC]
        
        tabBar.tintColor = .systemPurple
        
        setupMiddleButton()
    }
    
    private func setupMiddleButton() {
        let middleButton = UIButton()
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        middleButton.setImage(UIImage(systemName: "plus"), for: .normal)
        middleButton.backgroundColor = UIColor.systemPurple
        middleButton.tintColor = .white
        middleButton.layer.cornerRadius = 28
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.3
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        tabBar.addSubview(middleButton)
        
        NSLayoutConstraint.activate([
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 10),
            middleButton.widthAnchor.constraint(equalToConstant: 56),
            middleButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
    }
    
    @objc private func middleButtonTapped() {
        print("нажата кнопка +")
        let createLotVC = CreateLotPageViewController(viewModel: CreateLotViewModel())
        let navController = UINavigationController(rootViewController: createLotVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
