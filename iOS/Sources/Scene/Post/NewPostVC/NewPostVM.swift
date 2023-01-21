import Foundation
import RxSwift
import RxCocoa

class NewPostVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let buttonDidTap: Signal<Void>
        let newTitle: Driver<String>
        let newContent: Driver<String>
        let scheduleID: Driver<Int>
    }
    struct Output {
        let postResult: PublishRelay<Bool>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let postResult = PublishRelay<Bool>()
        let params = Driver.combineLatest(input.newTitle, input.newContent, input.scheduleID)
        input.buttonDidTap.asObservable()
            .withLatestFrom(params)
            .flatMap { title, content, id in
                api.sendNewPost(title, content, id)
            }
            .subscribe(onNext: { res in
                switch res {
                case .createOk:
                    postResult.accept(true)
                case .notFound:
                    print("404 not found")
                    postResult.accept(false)
                default:
                    postResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(postResult: postResult)
    }
}
