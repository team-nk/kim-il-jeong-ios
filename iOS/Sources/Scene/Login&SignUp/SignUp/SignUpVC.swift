import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class SignUpVC: BaseVC {
    private let viewModel = SignUpViewModel()
    private let signUpLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.textColor.color
        $0.text = "SignUp"
        $0.font = .systemFont(ofSize: 34, weight: .bold)
        $0.textAlignment = .center
    }
    private let emailTextField = UITextField().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = KimIlJeongColor.mainColor.color.cgColor
        $0.layer.borderWidth = 1
        $0.placeholder = "이메일을 입력해 주세요"
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.addLeftPadding()
    }
    private let emailCheckButton = UIButton(type: .system).then {
        $0.layer.cornerRadius = 10
        $0.setTitle("이메일 인증", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.backgroundColor = KimIlJeongColor.surface2.color
    }
    private let emailCodeTextField = UITextField().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = KimIlJeongColor.mainColor.color.cgColor
        $0.layer.borderWidth = 1
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.placeholder = "인증번호를 입력해 주세요"
        $0.addLeftPadding()
    }
    private let codeCheckButton = UIButton(type: .system).then {
        $0.layer.cornerRadius = 10
        $0.setTitle("확인하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.backgroundColor = KimIlJeongColor.surface2.color
    }
    private let idTextField = UITextField().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = KimIlJeongColor.mainColor.color.cgColor
        $0.layer.borderWidth = 1
        $0.placeholder = "아이디를 입력해 주세요"
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.addLeftPadding()
    }
    private let idCheckButton = UIButton(type: .system).then {
        $0.layer.cornerRadius = 10
        $0.setTitle("중복 확인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.backgroundColor = KimIlJeongColor.surface2.color
    }
    private let passwordTextField = UITextField().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = KimIlJeongColor.mainColor.color.cgColor
        $0.layer.borderWidth = 1
        $0.placeholder = "Password를 입력하세요"
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.addLeftPadding()
    }
    private let passwordCheckTextField = UITextField().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = KimIlJeongColor.mainColor.color.cgColor
        $0.layer.borderWidth = 1
        $0.placeholder = "Password를 한번 더 입력하세요"
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.addLeftPadding()
    }
    private let noticePasswordLabel = UILabel().then {
        $0.text = "비밀번호는 숫자 + 영문자 + 특수기호를 사용하여 8~15글자로 만들어 주세요."
        $0.font = .systemFont(ofSize: 11, weight: .regular)
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.textAlignment = .center
    }
    private let noticeLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.errorColor.color
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
    }
    private let nextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.backgroundColor = KimIlJeongColor.mainColor.color
        $0.setTitleColor(KimIlJeongColor.surfaceColor.color, for: .normal)
        $0.layer.cornerRadius = 10
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadData (_:)),
            name: NSNotification.Name("signUp"),
            object: nil
        )
    }
    @objc func reloadData(_ notification: Notification) {
        self.navigationController?.popViewController(animated: true)
    }
    override func bind() {
        let input = SignUpViewModel.Input(emailText: emailTextField.rx.text.orEmpty.asDriver(),
                                          codeText: emailCodeTextField.rx.text.orEmpty.asDriver(),
                                          idText: idTextField.rx.text.orEmpty.asDriver(),
                                          paswwordText: passwordTextField.rx.text.orEmpty.asDriver(),
                                          paswwordCheckText: passwordCheckTextField.rx.text.orEmpty.asDriver(),
                                          emailCheckButtonDidTap: emailCheckButton.rx.tap.asSignal(),
                                          codeCheckButtonDidTap: codeCheckButton.rx.tap.asSignal(),
                                          idCheckButtonDidTap: idCheckButton.rx.tap.asSignal(),
                                          signUpButtonDidTap: nextButton.rx.tap.asSignal())
        let output = viewModel.transform(input)
        output.signUpResult.subscribe(onNext: { [self] in
                switch $0 {
                case true:
                    let signUpCustomAlertVC = SignUpCustomAlertVC()
                    signUpCustomAlertVC.modalTransitionStyle = .crossDissolve
                    signUpCustomAlertVC.modalPresentationStyle = .overFullScreen
                    present(signUpCustomAlertVC, animated: true)
//                    navigationController?.popViewController(animated: true)
                    print("회원가입 완료")
                case false:
                    print("회원가입 실패")
                }
            }).disposed(by: disposeBag)
        output.emailCheckResult.subscribe(onNext: {
            $0 ? print("email code 보냄") : print("email code 실패")
        }).disposed(by: disposeBag)
        output.codeCheckResult.subscribe(onNext: {
            $0 ?  print("인증번호가 맞음") : print("인증번호가 다름")
        }).disposed(by: disposeBag)
        output.idCheckResult.subscribe(onNext: {
            $0 ? print("id 중복 아님") : print("id 중복!!")
        }).disposed(by: disposeBag)
        output.error.subscribe(onNext: { [self] in
            noticeLabel.text = $0
        }).disposed(by: disposeBag)
    }
    override func configureVC() {
        passwordTextField.rx.text.orEmpty
            .filter {!$0.isEmpty}
            .map { $0.validpassword() }
            .subscribe(onNext: { [self] in
                switch $0 {
                case true:
                    noticePasswordLabel.textColor = KimIlJeongColor.textColor.color
                    print("비밀번호 형식 맞음")
                case false:
                    noticePasswordLabel.textColor = KimIlJeongColor.errorColor.color
                    print("비밀번호 형식 오류")
                }
            }).disposed(by: disposeBag)
        passwordCheckTextField.rx.text.orEmpty
            .filter {!$0.isEmpty}
            .map {return $0 == self.passwordTextField.text}
            .subscribe(onNext: { [self] in
                switch $0 {
                case true:
                    viewModel.isRePasswordCheck = true
                case false:
                    viewModel.isRePasswordCheck = false
                }
            }).disposed(by: disposeBag)
    }
    override func addView() {
        [
            signUpLabel, emailTextField,
            emailCheckButton, emailCodeTextField,
            codeCheckButton, idTextField,
            idCheckButton, passwordTextField,
            passwordCheckTextField, noticePasswordLabel,
            noticeLabel, nextButton
        ].forEach {
            view.addSubview($0)
        }
    }
    // swiftlint:disable function_body_length
    override func setLayout() {
        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(44)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(signUpLabel.snp.bottom).offset(84)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalToSuperview().inset(83)
            $0.height.equalTo(50)
        }
        emailCheckButton.snp.makeConstraints {
            $0.top.equalTo(signUpLabel.snp.bottom).offset(84)
            $0.width.equalTo(114)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        emailCodeTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalToSuperview().inset(83)
            $0.height.equalTo(50)
        }
        codeCheckButton.snp.makeConstraints {
            $0.top.equalTo(emailCheckButton.snp.bottom).offset(15)
            $0.width.equalTo(114)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(emailCodeTextField.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalToSuperview().inset(83)
            $0.height.equalTo(50)
        }
        idCheckButton.snp.makeConstraints {
            $0.top.equalTo(codeCheckButton.snp.bottom).offset(15)
            $0.width.equalTo(114)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        noticePasswordLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(passwordCheckTextField.snp.bottom)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        noticeLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(24)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}
