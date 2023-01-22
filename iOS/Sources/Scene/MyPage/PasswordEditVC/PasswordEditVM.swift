import Foundation
import RxSwift
import RxCocoa

class PasswordEditVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let oldPassword: Driver<String>
        let newPassword: Driver<String>
        let newPasswordCheck: Driver<String>
        let buttonDidTap: Signal<Void>
    }
    struct Output {
        let patchResult: PublishRelay<Bool>
        let errorMessage: PublishRelay<String>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let patchResult = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        let info = Driver.combineLatest(
            input.oldPassword,
            input.newPassword,
            input.newPasswordCheck
        )
        input.buttonDidTap.asObservable()
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
                    errorMessage.accept($0)
                } else {
                    errorMessage.accept($0)
                }
            }).disposed(by: disposeBag)
        input.buttonDidTap.asObservable()
            .withLatestFrom(info)
            .flatMap { old, new, check in
                api.patchMyPassword(old, new, check)
            }
            .subscribe(onNext: { res in
                switch res {
                case .deleteOk:
                    patchResult.accept(true)
                default:
                    patchResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(patchResult: patchResult, errorMessage: errorMessage)
    }
}
