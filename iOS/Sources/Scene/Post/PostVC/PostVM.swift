import Foundation
import RxSwift
import RxCocoa

class PostVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let getContent: Driver<Void>
        let postId: Driver<Int>
    }
    struct Output {
        let getResult: PublishRelay<Bool>
        let postDetail: BehaviorRelay<PostDetailModel?>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getResult = PublishRelay<Bool>()
        let postDetail = BehaviorRelay<PostDetailModel?>(value: nil)
        input.getContent.asObservable()
            .withLatestFrom(input.postId)
            .flatMap { postID in
                api.fetchDetailPost(postID)
        }.subscribe(onNext: { data, res in
            switch res {
            case .getOk:
                postDetail.accept(data.self)
                getResult.accept(true)
            default:
                print(res)
                getResult.accept(false)
            }
        }).disposed(by: disposeBag)
        return Output(getResult: getResult, postDetail: postDetail)
    }
}
