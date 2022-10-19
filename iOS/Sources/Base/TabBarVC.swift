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
//        let calendarVC = CalendarVC(reactor: CalendarVCReactor())
//        calendarVC.tabBarItem = UITabBarItem(
//            title: "",
//            image: UIImage(named: "Calendar"),
//            selectedImage: UIImage(named: "Calendar_fill")
//        )
//        let mapVC = MapVC(reactor: MapVCReactor())
//        mapVC.tabBarItem = UITabBarItem(
//            title: "",
//            image: UIImage(named: "Map"),
//            selectedImage: UIImage(named: "Map_fill")
//        )
        let postListVC = PostListVC(reactor: PostListVCReactor())
        postListVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Megaphone"),
            selectedImage: UIImage(named: "Megaphone_fill")
        )
//        let myPageVC = MyPageVC(reactor: MyPageVCReactor())
//        myPageVC.tabBarItem = UITabBarItem(
//            title: "",
//            image: UIImage(named: "Person"),
//            selectedImage: UIImage(named: "Person_fill")
//        )
        viewControllers = [
//            calendarVC,
//            mapVC,
            postListVC
//            myPageVC
        ]
    }
}
