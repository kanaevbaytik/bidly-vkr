import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let viewModel = CreateLotViewModel()
        
        let mainVC = UINavigationController(rootViewController: MainViewController())
        let myBidsVC = UINavigationController(rootViewController: ChatListViewController())
        let addLotVC = UINavigationController(rootViewController: EnterLotDetailsViewController(viewModel: viewModel))
        let notificationsVC = UINavigationController(rootViewController: NotificationsViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        mainVC.tabBarItem = UITabBarItem(title: "Главное", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        myBidsVC.tabBarItem = UITabBarItem(title: "Чат", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        addLotVC.tabBarItem = UITabBarItem(title: "", image: nil, selectedImage: nil)
        notificationsVC.tabBarItem = UITabBarItem(title: "Уведомления", image: UIImage(systemName: "bell"), selectedImage: UIImage(systemName: "bell.fill"))
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.viewControllers = [mainVC, myBidsVC, addLotVC, notificationsVC, profileVC]
        
        tabBar.tintColor = UIColor(hex: "#AEA1E5FF")
        
        setupMiddleButton()
    }
    
    private func setupMiddleButton() {
        let middleButton = UIButton()
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        middleButton.setImage(UIImage(systemName: "plus"), for: .normal)
        middleButton.backgroundColor = UIColor(hex: "#56549EFF")
        middleButton.tintColor = .white
        middleButton.layer.cornerRadius = 20
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
