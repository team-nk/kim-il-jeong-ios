import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SignUpCustomAlertVC: BaseVC {
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let titleLabel = UILabel().then {
        $0.text = "회원가입이 완료되었습니다!"
        $0.textColor = KimIlJeongAsset.Color.textColor.color
        $0.font = .systemFont(ofSize: 18, weight: .bold )
        $0.textAlignment = .center
    }
    private let subTitleLabel = UILabel().then {
        $0.text = "확인 버튼을 누르면 로그인 화면으로 이동합니다. 다시 로그인 해 주세요"
        $0.textColor = KimIlJeongAsset.Color.description.color
        $0.font = .systemFont(ofSize: 15, weight: .regular )
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    private let doneButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongColor.mainColor.color
        $0.setTitleColor(KimIlJeongAsset.Color.surfaceColor.color, for: .normal)
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 10
    }

    override func addView() {
        view.addSubview(popupView)
        [
            titleLabel,
            subTitleLabel,
            doneButton
        ].forEach {popupView.addSubview($0)}
    }
    override func setLayout() {
        popupView.snp.makeConstraints {
            $0.width.equalTo(328)
            $0.height.equalTo(230)
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.width.equalTo(290)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.width.equalTo(290)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        doneButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            $0.width.equalTo(290)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
    }
    override func configureVC() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        doneButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: false) {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("signUp"),
                        object: nil,
                        userInfo: nil
                    )
                }
            }).disposed(by: disposeBag)
    }
}
