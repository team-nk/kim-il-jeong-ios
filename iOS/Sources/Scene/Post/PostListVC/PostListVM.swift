import Foundation
import RxSwift
import RxCocoa

class PostListVM: BaseVM {
    private let disposeBag = DisposeBag()
    struct Input {
        let getLists: Driver<Void>
        let selectedIndex: Signal<IndexPath>
    }
    struct Output {
        let birthUsers: BehaviorRelay<[Users]>
        let posts: BehaviorRelay<[Posts]>
        let getListResult: PublishRelay<Bool>
        let postDetail: BehaviorRelay<Posts?>
    }
    func transform(_ input: Input) -> Output {
        let api = Service()
        let birthUsers = BehaviorRelay<[Users]>(value: [])
        let posts = BehaviorRelay<[Posts]>(value: [])
        let getListResult = PublishRelay<Bool>()
        let postDetail = BehaviorRelay<Posts?>(value: nil)
        input.getLists.asObservable()
            .flatMap { _ in
            api.fetchBirthdayUsers()
        }.subscribe(onNext: { data, res in
            switch res {
            case .getOk:
                birthUsers.accept(data!.userList)
                getListResult.accept(true)
            default:
                print(res)
                getListResult.accept(false)
            }
        }).disposed(by: disposeBag)
        input.getLists.asObservable()
            .flatMap { _ in
            api.fetchAllPosts()
        }.subscribe(onNext: { data, res in
            switch res {
            case .getOk:
                posts.accept(data!.postList)
                getListResult.accept(true)
            default:
                print(res)
                getListResult.accept(false)
            }
        }).disposed(by: disposeBag)
        input.selectedIndex.asObservable()
            .subscribe(onNext: { index in
                let value = posts.value
                postDetail.accept(value[index.row].self)
            }).disposed(by: disposeBag)
        return Output(
            birthUsers: birthUsers,
            posts: posts,
            getListResult: getListResult,
            postDetail: postDetail
        )
    }
}
