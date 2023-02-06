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
        let imageURL: Driver<String?>
    }
    struct Output {
        let requestResult: PublishRelay<Bool>
        let errorMessage: PublishRelay<String>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let requestResult = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        let data = Driver.combineLatest(input.email, input.accountID, input.imageURL)
        input.buttonDidTap.asObservable()
            .flatMap { data }
            .map {
                if $0.0.isEmpty {
                    return "이메일을 입력해주세요."
                } else if $0.1.isEmpty {
                    return "아이디를 입력해주세요."
                } else {
                    return ""
                }
            }
            .subscribe(onNext: {
                errorMessage.accept($0)
            }).disposed(by: disposeBag)
        input.buttonDidTap.asObservable()
            .withLatestFrom(data)
            .flatMap { email, id, url in
                api.patchNewProfile(email, id, url ?? "")
            }.subscribe(onNext: { res in
                switch res {
                case .deleteOk:
                    requestResult.accept(true)
                default:
                    requestResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(requestResult: requestResult, errorMessage: errorMessage)
    }
}
