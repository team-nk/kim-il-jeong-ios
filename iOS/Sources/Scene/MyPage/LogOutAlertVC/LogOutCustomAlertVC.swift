import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LogOutCustomAlertVC: BaseVC {
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    private let titleLabel = UILabel().then {
        $0.text = "로그아웃 하시겠습니까?"
        $0.textColor = KimIlJeongAsset.Color.textColor.color
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .center
    }
    private let cancelButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.surfaceColor.color
        $0.setTitleColor(KimIlJeongAsset.Color.textColor.color, for: .normal)
        $0.setTitle("취소하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 10
    }
    private let logOutButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.mainColor.color
        $0.setTitleColor(KimIlJeongAsset.Color.surfaceColor.color, for: .normal)
        $0.setTitle("로그아웃", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 10
    }

    override func addView() {
        view.addSubview(popupView)
        [
            titleLabel,
            cancelButton,
            logOutButton
        ] .forEach {
            popupView.addSubview($0)
        }
    }
    override func configureVC() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        logOutButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true)
            isLogOutTapped.accept(true)
            Token.removeToken()
        }).disposed(by: disposeBag)
    }
    override func setLayout() {
        popupView.snp.makeConstraints {
            $0.width.equalTo(328)
            $0.height.equalTo(170)
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(19)
            $0.height.equalTo(40)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.width.equalTo(135)
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().inset(19)
        }
        logOutButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.width.equalTo(135)
            $0.height.equalTo(50)
            $0.trailing.equalToSuperview().inset(19)
        }
    }
}
