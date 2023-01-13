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
        let myNextPost: BehaviorRelay<Posts?>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let posts = BehaviorRelay<[Posts]>(value: [])
        let getListResult = PublishRelay<Bool>()
        let myNextPost = BehaviorRelay<Posts?>(value: nil)
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
                myNextPost.accept(value[index.row].self)
            }).disposed(by: disposeBag)
        return Output(
            posts: posts,
            getListResult: getListResult,
            myNextPost: myNextPost)
    }
}
