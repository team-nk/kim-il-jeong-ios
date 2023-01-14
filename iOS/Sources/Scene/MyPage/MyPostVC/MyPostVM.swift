import Foundation
import RxSwift
import RxCocoa

class MyPostVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let getLists: Driver<Void>
        let selectedIndex: Signal<IndexPath>
    }
    struct Output {
        let posts: BehaviorRelay<[Posts]>
        let getListResult: PublishRelay<Bool>
        let postID: BehaviorRelay<Int>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let posts = BehaviorRelay<[Posts]>(value: [])
        let getListResult = PublishRelay<Bool>()
        let postID =  BehaviorRelay<Int>(value: 0)
        input.getLists.asObservable()
            .flatMap { _ in
                api.fetchAllPosts()
        }.subscribe(onNext: { data, res in
            switch res {
            case .getOk:
                posts.accept(data!.postList.filter { $0.mine == true })
                getListResult.accept(true)
            default:
                print(res)
                getListResult.accept(false)
            }
        }).disposed(by: disposeBag)
        input.selectedIndex.asObservable()
            .subscribe(onNext: { index in
                let value = posts.value
                postID.accept(value[index.row].id)
            }).disposed(by: disposeBag)
        return Output(
            posts: posts,
            getListResult: getListResult,
            postID: postID
        )
    }
}
