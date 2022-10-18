import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
class EmailLoginVC: BaseVC<EmailLoginReactor> {
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
    private let emailTextField = UITextField().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = KimIlJeongColor.mainColor.color.cgColor
        $0.layer.borderWidth = 1
        $0.placeholder = "Email을 입력하세요"
        $0.addLeftPadding()
    }
    private let passwordTextField = UITextField().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = KimIlJeongColor.mainColor.color.cgColor
        $0.layer.borderWidth = 1
        $0.placeholder = "Password를 입력하세요"
        $0.addLeftPadding()
    }
    private let loginButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongColor.mainColor.color
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.cornerRadius = 10

    }
    private let signUpButton = UIButton(type: .system).then {
        $0.setTitle("김일정이 처음이신가요? 회원가입", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setUnderline(start: 13)
    }
    override func addView() {
        [
            logoImageView,
            kimIlJeongLabel,
            loginLabel,
            emailTextField,
            passwordTextField,
            loginButton,
            signUpButton
        ].forEach {
            view.addSubview($0)
        }
    }
    override func configureVC() {
        self.navigationItem.hidesBackButton = true
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email을 입력하세요.",
            attributes: [NSAttributedString.Key.foregroundColor: KimIlJeongColor.textfieldDeactivationColor.color])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password을 입력하세요.",
            attributes: [NSAttributedString.Key.foregroundColor: KimIlJeongColor.textfieldDeactivationColor.color])
        passwordTextField.isSecureTextEntry = true
        signUpButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(SignUpVC(reactor: SignUpReactor()), animated: true)
            }).disposed(by: disposeBag)
        loginButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(50)
            $0.top.equalToSuperview().inset(150)
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
        emailTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(loginLabel.snp.bottom).offset(85)
            $0.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(emailTextField.snp.bottom).offset(15)
            $0.height.equalTo(50)
        }
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(15)
            $0.height.equalTo(50)
        }
        signUpButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(210)
            $0.height.equalTo(24)
        }
    }
}
