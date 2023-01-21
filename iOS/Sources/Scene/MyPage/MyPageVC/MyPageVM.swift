import Foundation
import RxSwift
import RxCocoa

class MyPageVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let getMyInfo: Driver<Void>
    }
    struct Output {
        let myInfo: BehaviorRelay<UserInfoModel?>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let myInfo = BehaviorRelay<UserInfoModel?>(value: nil)
        input.getMyInfo.asObservable()
            .flatMap { _ in
                api.fetchMyInfo()
            }.subscribe(onNext: { data, res in
                switch res {
                case .getOk:
                    myInfo.accept(data)
                default:
                    print(res)
                }
            }).disposed(by: disposeBag)
        return Output(myInfo: myInfo)
    }
}
