import Foundation
import RxSwift
import RxCocoa

class MyBirthSheetVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let buttonDidTap: Driver<Void>
        let birthDate: Driver<String>
    }
    struct Output {
        let postResult: PublishRelay<Bool>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let postResult = PublishRelay<Bool>()
        let value = Driver.combineLatest(input.buttonDidTap, input.birthDate)
        input.buttonDidTap.asObservable()
            .withLatestFrom(value)
            .flatMap { _, date in
                api.patchMyBirthday(date)
            }
            .subscribe(onNext: { res in
                switch res {
                case .deleteOk:
                    postResult.accept(true)
                default:
                    postResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(postResult: postResult)
    }
}
