import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewImageVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let postNewImg: Driver<Void>
        let newProfileImg: Driver<UIImage?>
    }
    struct Output {
        let getResult: PublishRelay<Bool>
        let imageURL: BehaviorRelay<String>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getResult = PublishRelay<Bool>()
        let imageURL = BehaviorRelay<String>(value: "")
        let data = Driver.combineLatest(input.postNewImg, input.newProfileImg)
        input.postNewImg.asObservable()
            .withLatestFrom(data)
            .flatMap { _, image in
                api.postNewImage((image ?? UIImage(named: "NoneProfile"))!)
            }.subscribe(onNext: { data, res in
                switch res {
                case .getOk:
                    imageURL.accept(data?.imgURL ?? "nothing saved")
                    getResult.accept(true)
                default:
                    getResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(getResult: getResult, imageURL: imageURL)
    }
}
