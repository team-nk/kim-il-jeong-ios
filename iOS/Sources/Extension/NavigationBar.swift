import UIKit
extension BaseVC {
    func setNavigation() {
        self.navigationController?.navigationBar.backItem?.title = ""
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = KimIlJeongAsset.Color.backGroundColor2.color
            appearance.titleTextAttributes = [
                .foregroundColor: KimIlJeongAsset.Color.textColor.color,
                .font: UIFont.systemFont(ofSize: 17, weight: .bold)
            ]
            appearance.shadowColor = .clear
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
