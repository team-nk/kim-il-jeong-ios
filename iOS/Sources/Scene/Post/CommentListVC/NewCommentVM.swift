import Foundation
import RxSwift
import RxCocoa

class NewCommentVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let commentContent: Driver<String>
        let postID: Driver<Int>
        let buttonDidTap: Signal<Void>
    }
    struct Output {
        let postResult: PublishRelay<Bool>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let postResult = PublishRelay<Bool>()
        let value = Driver.combineLatest(input.commentContent, input.postID)
        input.buttonDidTap.asObservable()
            .withLatestFrom(value)
            .flatMap { content, id in
                api.sendNewComment(content, id)
            }.subscribe(onNext: { res in
                switch res {
                case .createOk:
                    postResult.accept(true)
                default:
                    postResult.accept(false)
                }
            }).disposed(by: disposeBag)
        return Output(postResult: postResult)
    }
}
