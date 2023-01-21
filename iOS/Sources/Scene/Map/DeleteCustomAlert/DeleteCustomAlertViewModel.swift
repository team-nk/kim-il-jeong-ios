import Foundation

import RxSwift
import RxCocoa

class DeleteCustomAlertViewModel: BaseVM {

    struct Input {
        let scheduleId: Int
        let deleteButtonDidTap: Signal<Void>
    }

    struct Output {
        let deleteResult: PublishRelay<Bool>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let api = Service()
        let deleteResult = PublishRelay<Bool>()
        input.deleteButtonDidTap.asObservable()
            .flatMap {
                api.deleteSchedule(input.scheduleId) }
            .subscribe(onNext: { res in
                res == .deleteOk ? deleteResult.accept(true) : deleteResult.accept(false)
            }).disposed(by: disposeBag)
        return Output(deleteResult: deleteResult)
    }
}
