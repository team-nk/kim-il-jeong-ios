import UIKit
import RxSwift
import RxCocoa
import RxFlow

class TabBarVC: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTabBarLayout()
        setUpTabBarItem()
    }

    func setUpTabBarLayout() {
        let tabBar: UITabBar = self.tabBar
        tabBar.barTintColor = UIColor(named: "BackGroundColor")
        tabBar.unselectedItemTintColor = UIColor(named: "Description")
        tabBar.tintColor = UIColor(named: "TextColor")
        self.hidesBottomBarWhenPushed = true
    }

    func setUpTabBarItem() {
        let mainVC = MainVC()
        mainVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Calendar"),
            selectedImage: UIImage(named: "Calendar_fill")
        )
        let postListVC = PostListVC()
        postListVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Megaphone"),
            selectedImage: UIImage(named: "Megaphone_fill")
        )
        viewControllers = [
            mainVC,
            postListVC
        ]
    }
}
