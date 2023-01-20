import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
class LoginVC: BaseVC {

    private let logoImageView = UIImageView().then {
        $0.image = KimIlJeongImage.logo.image
    }
    private let kimIlJeongLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.textColor.color
        $0.text = "Kim il jeong"
        $0.font = .systemFont(ofSize: 32, weight: .semibold)
    }
    private let loginLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.mainColor.color
        $0.text = "Login"
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
    }
    private let emailLoginButton = UIButton(type: .system).then {
        $0.setTitle("이메일로 로그인하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setUnderline(start: 0)
    }
    private let googleLoginButton = UIButton().then {
        $0.setImage(KimIlJeongImage.google.image, for: .normal)
    }
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(KimIlJeongImage.kakao.image, for: .normal)
    }
    override func addView() {
        [
            logoImageView,
            kimIlJeongLabel,
            loginLabel,
            googleLoginButton,
            kakaoLoginButton,
            emailLoginButton
        ].forEach {
            view.addSubview($0)
        }
    }
    override func configureVC() {
        emailLoginButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(EmailLoginVC(), animated: true)
            }).disposed(by: disposeBag)
    }
    override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(50)
            $0.top.equalToSuperview().inset(148)
            $0.width.equalTo(40)
            $0.height.equalTo(42.58)
        }
        kimIlJeongLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.top.equalToSuperview().inset(199)
        }
        loginLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(50)
            $0.top.equalTo(kimIlJeongLabel.snp.bottom).offset(8)
        }
        googleLoginButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerX.equalToSuperview().offset(-50)
            $0.bottom.equalTo(emailLoginButton.snp.top).offset(-30)
        }
        kakaoLoginButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerX.equalToSuperview().offset(50)
            $0.bottom.equalTo(emailLoginButton.snp.top).offset(-30)
        }
        emailLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
            $0.width.equalTo(210)
            $0.height.equalTo(24)
        }
    }
}
