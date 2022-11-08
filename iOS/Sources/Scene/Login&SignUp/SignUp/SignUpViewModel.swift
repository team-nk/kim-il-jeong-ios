import Foundation

import RxSwift
import RxCocoa

class SignUpViewModel: BaseVM {

    struct Input {
        let emailText: Driver<String>
        let emailCheckText: Driver<String>
        let idText: Driver<String>
        let paswwordText: Driver<String>
        let paswwordCheckText: Driver<String>
        let buttonDidTap: Signal<Void>
    }

    struct Output {
        let error: PublishRelay<String>
        let success: PublishRelay<Bool>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let error = PublishRelay<String>()
        let success = PublishRelay<Bool>()
        let info = Driver.combineLatest(
            input.emailText,
            input.emailCheckText,
            input.idText,
            input.paswwordText,
            input.paswwordCheckText)

        input.buttonDidTap
            .asObservable()
            .flatMap { info }
            .map {
                if $0.0.isEmpty {
                    return "이메일 인증을 해주세요"
                } else if $0.1.isEmpty {
                    return "1"
                } else if $0.2.isEmpty {
                    return "아이디 중복 확인을 해주세요"
                } else if $0.3.isEmpty {
                    return "비밀번호를 입력을 해주세요"
                } else if $0.4.isEmpty {
                    return "비밀번호가 다릅니다"
                } else {
                    return ""
                }
            }
            .subscribe(onNext: {
                if $0 == "" {
                    error.accept($0)
                    success.accept(true)
                } else {
                    error.accept($0)
                }
            }).disposed(by: disposeBag)

        return Output(error: error, success: success)
    }
}
