import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let authViewController = AuthViewController()
        let tabBarController = CustomTabBarController()
        let navigationController = UINavigationController(rootViewController: authViewController)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
