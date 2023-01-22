import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class MyPostVC: BaseVC {
    private let getPosts = BehaviorRelay<Void>(value: ())
    private let viewModel = MyPostVM()
    private let nextPost = BehaviorRelay<Posts?>(value: nil)
    private let nextID = BehaviorRelay<Int>(value: 0)
    private var nextColor = String()
    let myPostTableView = UITableView().then {
        $0.register(ScheduleCell.self, forCellReuseIdentifier: "MyPostsCell")
        $0.rowHeight = 80
        $0.separatorInset.left = 16
        $0.separatorInset.right = 15
        $0.backgroundColor = KimIlJeongColor.backGroundColor2.color
        $0.showsVerticalScrollIndicator = false
    }
    override func bind() {
        let input = MyPostVM.Input(
            getLists: getPosts.asDriver(onErrorJustReturn: ()),
            selectedIndex: myPostTableView.rx.itemSelected.asSignal()
        )
        let output = viewModel.transform(input)
        output.posts.bind(to: myPostTableView.rx.items(
            cellIdentifier: "MyPostsCell",
            cellType: ScheduleCell.self)) { _, items, cell in
                cell.scheduleTitle.text = items.title
                cell.scheduleOwner.text = items.accountId
                cell.scheduleContent.text = items.scheduleContent
                cell.scheduleDate.text = items.createTime
                cell.scheduleLocation.text = items.address
                cell.colorSetting.tintColor = items.color.colorDistinction()
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        output.postID
            .subscribe(onNext: {
                self.nextID.accept($0)
            }).disposed(by: disposeBag)
        myPostTableView.rx.itemSelected
            .subscribe(onNext: { _ in
                self.cellDidTap()
            }).disposed(by: disposeBag)
    }
    private func cellDidTap() {
        let next = PostVC()
        next.postID.accept(nextID.value)
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(next, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "내 글 확인하기"
    }
    override func addView() {
        view.addSubview(myPostTableView)
    }
    override func configureVC() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "내 글 확인하기"
        setNavigation()
    }
    override func setLayout() {
        myPostTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(23)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}
