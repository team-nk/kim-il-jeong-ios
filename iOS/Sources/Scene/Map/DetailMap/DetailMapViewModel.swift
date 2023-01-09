import Foundation

import RxSwift
import RxCocoa

class DetailMapViewModel: BaseVM {

    struct Input {
        let viewAppear: Signal<Void>
    }

    struct Output {
        let myMapSchedules: BehaviorRelay<[MapScheduleList]>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let api = Service()
        let myMapSchedules = BehaviorRelay<[MapScheduleList]>(value: [])
        input.viewAppear.asObservable()
            .flatMap { api.getMapSchedules() }
            .subscribe(onNext: { data, res in
                switch res {
                case .getOk:
                    myMapSchedules.accept(data!.schedule_list)
                default:
                    return
                }
            }).disposed(by: disposeBag)
        return Output(myMapSchedules: myMapSchedules)
    }
}
