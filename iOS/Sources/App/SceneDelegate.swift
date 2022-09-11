import UIKit
import RxSwift
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let disposeBag: DisposeBag = .init()
    private let coordinator: FlowCoordinator = .init()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
//        let mainViewController = LoginVC(reactor: LoginReactor())
//        let naviMainViewController = UINavigationController(rootViewController: mainViewController)
//        naviMainViewController.navigationBar.isHidden = true
//        window?.rootViewController = naviMainViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }

}
