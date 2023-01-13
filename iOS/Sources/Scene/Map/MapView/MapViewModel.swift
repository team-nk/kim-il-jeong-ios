import Foundation

import RxSwift
import RxCocoa

class MapViewModel: BaseVM {

    struct Input {
        let viewAppear: Signal<Void>
    }

    struct Output {
        let locationList: BehaviorRelay<[LocationList]>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let api = Service()
        let locationList = BehaviorRelay<[LocationList]>(value: [])
        input.viewAppear.asObservable()
            .flatMap {
                api.getLocation() }
            .subscribe(onNext: { date, res in
                res == .getOk ? locationList.accept(date!.scheduleList) : locationList.accept([])
            }).disposed(by: disposeBag)
        return Output(locationList: locationList)
    }
}
