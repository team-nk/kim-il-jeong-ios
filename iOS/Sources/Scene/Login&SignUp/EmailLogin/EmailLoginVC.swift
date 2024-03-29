import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class EmailLoginVC: BaseVC {
    let viewModel: EmailLoginViewModel = .init()

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
        $0.autocapitalizationType = .none
        $0.setTextField(forTextField: $0, placeholderText: "Email을 입력하세요")
        $0.addLeftPadding()
    }
    private let passwordTextField = UITextField().then {
        $0.setTextField(forTextField: $0, placeholderText: "Password를 입력하세요")
        $0.isSecureTextEntry = true
        $0.addLeftPadding()
    }
    private let loginButton = UIButton(type: .system).then {
        $0.setButton(title: "로그인",
                     titleColor: KimIlJeongColor.surfaceColor.color,
                     backgroundColor: KimIlJeongColor.mainColor.color)
    }
    private let signUpButton = UIButton(type: .system).then {
        $0.setTitle("김일정이 처음이신가요? 회원가입", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setUnderline(start: 13)
    }
    override func bind() {
        let input = EmailLoginViewModel.Input(
            emailText: emailTextField.rx.text.orEmpty.asDriver(),
            passwordText: passwordTextField.rx.text.orEmpty.asDriver(),
            loginButtonDidTap: loginButton.rx.tap.asSignal())
        let output = viewModel.transform(input)
        output.result.subscribe(onNext: {[self] in
            switch $0 {
            case true:
                dismiss(animated: true)
                print("login 성공")
            case false:
                print("login 실패")
            }
        }).disposed(by: disposeBag)
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
        signUpButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(SignUpVC(), animated: true)
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
