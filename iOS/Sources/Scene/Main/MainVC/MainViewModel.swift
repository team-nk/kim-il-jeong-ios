import Foundation
import RxSwift
import RxCocoa

class MainViewModel: BaseVM {

    struct Input {
        let refresh: Signal<Void>
        let viewAppear: Signal<Void>
    }

    struct Output {
        let refreshResult: PublishRelay<Bool>
        let result: PublishRelay<Bool>
        let mySchedulesList: BehaviorRelay<[MyScheduleList]>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishRelay<Bool>()
        let refreshResult = PublishRelay<Bool>()
        let mySchedulesList = BehaviorRelay<[MyScheduleList]>(value: [])
        input.refresh
            .asObservable()
            .flatMap { api.refreshToken() }
            .subscribe(onNext: { res in
                switch res {
                case .getOk:
                    refreshResult.accept(true)
                default:
                    refreshResult.accept(false)
                }
            }).disposed(by: disposeBag)
        input.viewAppear
            .asObservable()
            .flatMap { api.getMySchedules() }
            .subscribe(onNext: { data, res in
                switch res {
                case .getOk:
                    mySchedulesList.accept(data!.schedule_list)
                default:
                    return
                }
            }).disposed(by: disposeBag)
        return Output(refreshResult: refreshResult, result: result, mySchedulesList: mySchedulesList)
    }
}
