import Foundation

import RxSwift
import RxCocoa

class DetailMapViewModel: BaseVM {

    struct Input {
        let viewAppear: Signal<Void>
        let selectedIndex: Signal<IndexPath>
    }

    struct Output {
        let myMapSchedules: BehaviorRelay<[MapScheduleList]>
        let nextData: BehaviorRelay<MapScheduleList?>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let api = Service()
        let myMapSchedules = BehaviorRelay<[MapScheduleList]>(value: [])
        let nextData = BehaviorRelay<MapScheduleList?>(value: nil)
        input.viewAppear.asObservable()
            .flatMap { api.getMapSchedules() }
            .subscribe(onNext: { data, res in
                res == .getOk ? myMapSchedules.accept(data!.schedule_list) : myMapSchedules.accept([])
            }).disposed(by: disposeBag)
        input.selectedIndex.asObservable()
            .subscribe(onNext: { index in
                let value = myMapSchedules.value
                nextData.accept(value[index.row].self)
            }).disposed(by: disposeBag)
        return Output(myMapSchedules: myMapSchedules, nextData: nextData)
    }
}
