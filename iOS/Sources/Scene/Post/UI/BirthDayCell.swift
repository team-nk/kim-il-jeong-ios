import UIKit
import Then
import SnapKit

class BirthDayCell: BaseTC {
    let backView = UIView().then {
        $0.backgroundColor = UIColor(named: "CellBackGroundColor")
        $0.layer.cornerRadius = 20
    }
    let megaphoneImage = UIImageView().then {
        $0.image = UIImage(named: "Megaphone")
    }
    let congratulationsLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "TextColor")
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    let dateLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "Description")
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    override func addView() {
        addSubview(backView)
        [
            megaphoneImage,
            congratulationsLabel,
            dateLabel
        ] .forEach {
            backView.addSubview($0)
        }
    }
    override func configureVC() {
        self.backgroundColor = KimIlJeongColor.backGroundColor2.color
    }
    override func setLayout() {
        megaphoneImage.snp.makeConstraints {
            $0.top.equalTo(backView).inset(28)
            $0.leading.equalTo(backView).inset(17)
            $0.bottom.equalTo(backView).inset(27.28)
            $0.size.width.height.equalTo(24.72)
        }
        congratulationsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(megaphoneImage.snp.trailing).offset(9.82)
            $0.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(congratulationsLabel.snp.bottom).offset(0)
            $0.leading.equalTo(megaphoneImage.snp.trailing).offset(9.82)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(20)
        }
        backView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(0)
            $0.trailing.equalToSuperview().inset(0)
            $0.height.equalTo(80)
        }
    }
}
