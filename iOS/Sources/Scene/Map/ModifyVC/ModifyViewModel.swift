import Foundation

import RxSwift
import RxCocoa

class ModifyViewModel: ViewModel {

    struct Input {
        let titleText: Driver<String>
    }

    struct Output {
        let title: PublishRelay<String>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let title = PublishRelay<String>()

        input.titleText.asObservable()
            .map { $0.count }
            .subscribe(onNext: { length in
                title.accept(String(length))
            }).disposed(by: disposeBag)
        return Output(title: title)
    }
}
