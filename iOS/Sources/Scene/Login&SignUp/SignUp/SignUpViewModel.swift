import Foundation

import RxSwift
import RxCocoa
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
class SignUpViewModel: BaseVM {

    private var isIdCheck: Bool = false
    private var isEmailCheck: Bool = false
    private var isCodeCheck: Bool = false
    var isRePasswordCheck: Bool = false

    struct Input {
        let emailText: Driver<String>
        let codeText: Driver<String>
        let idText: Driver<String>
        let paswwordText: Driver<String>
        let paswwordCheckText: Driver<String>
        let emailCheckButtonDidTap: Signal<Void>
        let codeCheckButtonDidTap: Signal<Void>
        let idCheckButtonDidTap: Signal<Void>
        let signUpButtonDidTap: Signal<Void>
    }

    struct Output {
        let emailCheckResult: PublishRelay<Bool>
        let codeCheckResult: PublishRelay<Bool>
        let idCheckResult: PublishRelay<Bool>
        let signUpResult: PublishRelay<Bool>
        let error: PublishRelay<String>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let api = Service()
        let signUpResult = PublishRelay<Bool>()
        let emailCheckResult = PublishRelay<Bool>()
        let codeCheckResult = PublishRelay<Bool>()
        let idCheckResult = PublishRelay<Bool>()
        let error = PublishRelay<String>()
        let signUp = Driver.combineLatest(
            input.emailText,
            input.codeText,
            input.idText,
            input.paswwordText,
            input.paswwordCheckText)
        let code = Driver.combineLatest(input.emailText, input.codeText)
        input.signUpButtonDidTap
            .asObservable()
            .map {
                if !self.isEmailCheck {
                    error.accept("이메일 인증을 해 주세요")
                } else if !self.isCodeCheck {
                    error.accept("인증번호 확인을 해 주세요")
                } else if !self.isIdCheck {
                    error.accept("아이디 중복 확인을 해 주세요")
                } else if !self.isRePasswordCheck {
                    error.accept("비밀번호가 다릅니다")
                }
            }
            .filter { self.isEmailCheck && self.isIdCheck && self.isCodeCheck && self.isRePasswordCheck}
            .withLatestFrom(signUp)
            .flatMap { email, code, accountId, password, rePassword in
                api.signUp(email, code, accountId, password, rePassword)
            }
            .subscribe(onNext: {
                switch $0 {
                case .createOk:
                    signUpResult.accept(true)
                default:
                    signUpResult.accept(false)
                }
            })
            .disposed(by: disposeBag)

        input.emailCheckButtonDidTap
            .asObservable()
            .withLatestFrom(input.emailText)
            .flatMap { email in
                api.sendEmail(email)
            }
            .subscribe(onNext: { [unowned self] in
                switch $0 {
                case .getOk:
                    isEmailCheck = true
                    emailCheckResult.accept(true)
                default:
                    isEmailCheck = false
                    emailCheckResult.accept(false)
                }
            }).disposed(by: disposeBag)

        input.codeCheckButtonDidTap
            .asObservable()
            .withLatestFrom(code)
            .flatMap { email, code in
                api.codeCheck(email, code)
            }.subscribe(onNext: { [unowned self] in
                switch $0 {
                case .getOk:
                    isCodeCheck = true
                    codeCheckResult.accept(true)
                default:
                    isCodeCheck = false
                    codeCheckResult.accept(false)
                }
            }).disposed(by: disposeBag)
        input.idCheckButtonDidTap
            .asObservable()
            .withLatestFrom(input.idText)
            .flatMap { acccountId in
                api.idCheck(acccountId)
            }.subscribe(onNext: { [unowned self] in
                switch $0 {
                case .getOk:
                    isIdCheck = true
                    idCheckResult.accept(true)
                default:
                    isIdCheck = false
                    idCheckResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(emailCheckResult: emailCheckResult,
                      codeCheckResult: codeCheckResult,
                      idCheckResult: idCheckResult,
                      signUpResult: signUpResult,
                      error: error)
    }
}
