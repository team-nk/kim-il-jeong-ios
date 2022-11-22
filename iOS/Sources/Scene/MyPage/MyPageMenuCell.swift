import UIKit
import Then
import SnapKit

class MyPageMenuCell: BaseTC {
    let nextButton = UIImageView().then {
        $0.image = UIImage(named: "NextButtonImage")
        $0.tintColor = KimIlJeongColor.textColor.color
    }
    let menuTitle = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    override func addView() {
        [
            menuTitle,
            nextButton
        ] .forEach {
            addSubview($0)
        }
    }
    override func configureVC() {
        self.backgroundColor = .clear
    }
    override func setLayout() {
        menuTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.height.equalTo(20)
            $0.leading.equalToSuperview().inset(16)
        }
        nextButton.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
}
