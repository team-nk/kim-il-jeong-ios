import Foundation
import RxSwift
import RxCocoa

class PasswordEditViewModel: BaseVM {
    struct Input {
        let oldPassword: Driver<String>
        let newPassword: Driver<String>
        let newPasswordCheck: Driver<String>
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
            input.oldPassword,
            input.newPassword,
            input.newPasswordCheck
        )

        input.buttonDidTap
            .asObservable()
            .flatMap { info }
            .map {
                if $0.0.isEmpty {
                    return "기존 비밀번호가 다릅니다."
                } else if $0.1 != $0.2 {
                    return "새로운 비밀번호가 일치하지 않습니다."
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
