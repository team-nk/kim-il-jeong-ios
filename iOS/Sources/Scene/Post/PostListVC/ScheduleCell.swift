import UIKit
import Then
import SnapKit

class ScheduleCell: BaseTC {
    let colorSetting = UIImageView().then {
        $0.tintColor = KimIlJeongColor.backGroundColor.color
        $0.image = UIImage(systemName: "circle.fill")
    }
    let scheduleTitle = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    let scheduleOwner = UILabel().then {
        $0.textAlignment = .right
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    let scheduleContent = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    let scheduleDate = UILabel().then {
        $0.textAlignment = .right
        $0.textColor = KimIlJeongColor.description.color
        $0.font = .systemFont(ofSize: 10, weight: .regular)
    }
    let scheduleLocation = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = KimIlJeongColor.description.color
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    override func addView() {
        [
            colorSetting,
            scheduleTitle,
            scheduleOwner,
            scheduleContent,
            scheduleDate,
            scheduleLocation
        ] .forEach {
            addSubview($0)
        }
    }
    override func configureVC() {
        self.backgroundColor = KimIlJeongColor.backGroundColor.color
    }
    override func setLayout() {
        colorSetting.snp.makeConstraints {
            $0.width.height.equalTo(5)
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(19)
            $0.bottom.equalToSuperview().inset(58)
        }
        scheduleTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalTo(colorSetting.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(135)
            $0.bottom.equalToSuperview().inset(51)
        }
        scheduleOwner.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalTo(scheduleTitle.snp.trailing).offset(0)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
        }
        scheduleContent.snp.makeConstraints {
            $0.top.equalTo(scheduleTitle.snp.bottom).offset(1)
            $0.leading.equalToSuperview().inset(19)
            $0.trailing.equalToSuperview().inset(90)
            $0.bottom.equalToSuperview().inset(30)
        }
        scheduleDate.snp.makeConstraints {
            $0.top.equalTo(scheduleOwner.snp.bottom).offset(0)
            $0.leading.equalTo(scheduleContent.snp.trailing).offset(0)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(30)
        }
        scheduleLocation.snp.makeConstraints {
            $0.top.equalTo(scheduleContent.snp.bottom).offset(1)
            $0.leading.equalToSuperview().inset(19)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}
