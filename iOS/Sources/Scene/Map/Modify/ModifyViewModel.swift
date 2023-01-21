import Foundation

import RxSwift
import RxCocoa

class ModifyViewModel: BaseVM {

    struct Input {
        let scheduleId: Int
        let contentText: Driver<String>
        let addressText: Driver<String>
        let colorText: Driver<String>
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
        let info = Driver.combineLatest(
            input.contentText, input.addressText, input.colorText,
            input.startTime, input.endTime, input.isAlways
        )
        input.doneButtonDidTap.asObservable()
            .withLatestFrom(info)
            .flatMap { content, address, color, startTime, endTime, isAlways in
                api.putSchedule(input.scheduleId, content, address,
                                color, startTime.dateFormateT(), endTime.dateFormateT(), isAlways)
            }.subscribe(onNext: { res in
                res == .deleteOk ? putScheduleResult.accept(true) : putScheduleResult.accept(false)
            }).disposed(by: disposeBag)

        let content = PublishRelay<String>()
        input.contentText.asObservable()
            .map { $0.count }
            .subscribe(onNext: { length in
                content.accept(String(length))
            }).disposed(by: disposeBag)
        return Output(putScheduleResult: putScheduleResult, content: content)
    }
}
