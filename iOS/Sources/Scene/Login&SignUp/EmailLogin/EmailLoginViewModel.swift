import Foundation

import RxSwift
import RxCocoa

class EmailLoginViewModel: BaseVM {

    struct Input {
        let emailText: Driver<String>
        let passwordText: Driver<String>
        let loginButtonDidTap: Signal<Void>
    }

    struct Output {
        let result: PublishRelay<Bool>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let api = Service()
        let info = Driver.combineLatest(input.emailText, input.passwordText)
        let result = PublishRelay<Bool>()
        input.loginButtonDidTap
            .asObservable()
            .withLatestFrom(info)
            .flatMap {email, password in
                api.login(email, password)
            }.subscribe(onNext: { res in
                switch res {
                case .getOk:
                    result.accept(true)
                default:
                    result.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(result: result)
    }
}
