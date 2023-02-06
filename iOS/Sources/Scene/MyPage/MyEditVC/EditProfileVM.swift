import Foundation
import UIKit
import RxSwift
import RxCocoa

class EditProfileVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let buttonDidTap: Signal<Void>
        let email: Driver<String>
        let accountID: Driver<String>
        let imageURL: Driver<String>
    }
    struct Output {
        let requestResult: PublishRelay<Bool>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let requestResult = PublishRelay<Bool>()
        let data = Driver.combineLatest(input.email, input.accountID, input.imageURL)
        input.buttonDidTap.asObservable()
            .withLatestFrom(data)
            .flatMap { email, id, url in
                api.patchNewProfile(email, id, url)
            }.subscribe(onNext: { res in
                switch res {
                case .deleteOk:
                    requestResult.accept(true)
                default:
                    requestResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(requestResult: requestResult)
    }
}
