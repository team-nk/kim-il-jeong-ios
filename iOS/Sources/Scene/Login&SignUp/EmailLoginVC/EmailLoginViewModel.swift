import Foundation

import RxSwift
import RxCocoa

class EmailLoginViewModel: ViewModel {

    struct Input {
        let text: Driver<String>
        let buttonDidTap: Signal<Void>
    }

    struct Output {
        let menu: PublishRelay<String>
    }

    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let menu = PublishRelay<String>()

        input.buttonDidTap
            .asObservable()
            .subscribe(onNext: {
                menu.accept("!!!!")
            })
            .disposed(by: disposeBag)

        return Output(menu: menu)
    }
}
