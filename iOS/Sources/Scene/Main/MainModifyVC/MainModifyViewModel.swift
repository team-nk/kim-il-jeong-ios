import Foundation

import RxSwift
import RxCocoa

class MainModifyViewModel: BaseVM {

    struct Input {
        let content: Driver<String>
        let address: Driver<String>
        let color: Driver<String>
        let startTime: Driver<String>
        let endTime: Driver<String>
        let isAlways: Driver<Bool>
        let doneButtonDidTap: Signal<Void>
    }

    struct Output {
        let postScheduleResult: PublishRelay<Bool>
        let content: PublishRelay<String>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let api = Service()
        let postScheduleResult = PublishRelay<Bool>()
        let info = Driver.combineLatest(input.content, input.address, input.color,
                                        input.startTime, input.endTime, input.isAlways)
        input.doneButtonDidTap.asObservable()
            .withLatestFrom(info)
            .flatMap { content, address, color, startTime, endTime, isAlways in
                api.postSchedule(content, address, color, startTime.dateFormateT(), endTime.dateFormateT(), isAlways) }
            .subscribe(onNext: { res in
                res == .createOk ? postScheduleResult.accept(true) : postScheduleResult.accept(false)
            }).disposed(by: disposeBag)

        let content = PublishRelay<String>()
        input.content.asObservable()
            .map { $0.count }
            .subscribe(onNext: { length in
                content.accept(String(length))
            }).disposed(by: disposeBag)
        return Output(postScheduleResult: postScheduleResult, content: content)
    }
}
