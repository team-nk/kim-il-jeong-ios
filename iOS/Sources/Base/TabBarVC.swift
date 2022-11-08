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
        tabBar.backgroundColor = KimIlJeongAsset.Color.backGroundColor2.color
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.layer.cornerRadius = 20
        self.hidesBottomBarWhenPushed = true
    }

    func setUpTabBarItem() {
        let mainVc = MainVC()
        mainVc.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Calendar"),
            selectedImage: UIImage(named: "Calendar_fill")
        )
        let mapVC = MapVC()
        mapVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Map"),
            selectedImage: UIImage(named: "Map_fill")
        )
        let postListVC = PostListVC()
        postListVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Megaphone"),
            selectedImage: UIImage(named: "Megaphone_fill")
        )
        let myVC = PostListVC()
        myVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Person"),
            selectedImage: UIImage(named: "Person_fill")
        )
        viewControllers = [
            mainVc,
            mapVC,
            postListVC,
            myVC
        ]
    }
}
