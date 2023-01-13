import Foundation
import RxSwift
import RxCocoa

class CommentListVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let getComments: Driver<Void>
        let postId: Driver<Int>
    }
    struct Output {
        let comments: BehaviorRelay<[Comments]>
        let getResult: PublishRelay<Bool>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let comments = BehaviorRelay<[Comments]>(value: [])
        let getListResult = PublishRelay<Bool>()
        input.getComments.asObservable()
            .withLatestFrom(input.postId)
            .flatMap { postID in
            api.fetchAllComments(postID)
        }.subscribe(onNext: { data, res in
            switch res {
            case .getOk:
                comments.accept(data!.commentList)
                getListResult.accept(true)
            default:
                print(res)
                getListResult.accept(false)
            }
        }).disposed(by: disposeBag)
        return Output(comments: comments, getResult: getListResult)
    }
}
