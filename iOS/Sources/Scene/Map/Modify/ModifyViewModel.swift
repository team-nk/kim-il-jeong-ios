import Foundation

import RxSwift
import RxCocoa

class ModifyViewModel: BaseVM {

    struct Input {
        let scheduleId: Int
        let content: Driver<String>
        let address: String
        let color: Driver<String>
        let startTime: Driver<String>
        let endTime: Driver<String>
        let isAlways: Driver<Bool>
        let doneButtonDidTap: Signal<Void>
    }

    struct Output {
        let putScheduleResult: PublishRelay<Bool>
        let content: PublishRelay<String>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let api = Service()
        let putScheduleResult = PublishRelay<Bool>()
        let info = Driver.combineLatest(input.content, input.color, input.startTime, input.endTime, input.isAlways)
        input.doneButtonDidTap.asObservable()
            .withLatestFrom(info)
            .flatMap { content, color, startTime, endTime, isAlways in
                api.putSchedule(input.scheduleId, content, input.address, color, startTime, endTime, isAlways) }
            .subscribe(onNext: { res in
                res == .deleteOk ? putScheduleResult.accept(true) : putScheduleResult.accept(false)
            }).disposed(by: disposeBag)

        let content = PublishRelay<String>()
        input.content.asObservable()
            .map { $0.count }
            .subscribe(onNext: { length in
                content.accept(String(length))
            }).disposed(by: disposeBag)
        return Output(putScheduleResult: putScheduleResult, content: content)
    }
}
