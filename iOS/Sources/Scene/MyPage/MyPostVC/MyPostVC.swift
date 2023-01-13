import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class MyPostVC: BaseVC {
    private let getPosts = BehaviorRelay<Void>(value: ())
    private let viewModel = MyPostVM()
    private let nextPost = BehaviorRelay<Posts?>(value: nil)
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
                switch items.color {
                case "RED":
                    cell.colorSetting.tintColor = KimIlJeongColor.errorColor.color
                case "BLUE":
                    cell.colorSetting.tintColor = KimIlJeongColor.mainColor.color
                case "YELLOW":
                    cell.colorSetting.tintColor = KimIlJeongColor.yellowColor.color
                case "GREEN":
                    cell.colorSetting.tintColor = KimIlJeongColor.greenColor.color
                case "PURPLE":
                    cell.colorSetting.tintColor = KimIlJeongColor.purpleColor.color
                default:
                    print("ColorEmpty")
                }
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        output.myNextPost
            .subscribe(onNext: {
                self.nextPost.accept($0)
            }).disposed(by: disposeBag)
        myPostTableView.rx.itemSelected
            .subscribe(onNext: { _ in
                self.cellDidTap()
            }).disposed(by: disposeBag)
    }
    private func cellDidTap() {
        let next = PostVC()
        next.isMyPost.accept(self.nextPost.value!.mine)
        next.postID.accept(self.nextPost.value!.id)
        next.postCommentCount.accept(self.nextPost.value!.commentCount)
        next.postTitleLabel.text = self.nextPost.value!.title
        switch nextPost.value!.color {
        case "RED":
            self.nextColor = "ErrorColor"
        case "BLUE":
            self.nextColor = "MainColor"
        case "YELLOW":
            self.nextColor = "YellowColor"
        case "GREEN":
            self.nextColor = "GreenColor"
        case "PURPLE":
            self.nextColor = "PurpleColor"
        default:
            print("ColorEmpty")
        }
        next.colorTag.tintColor = UIColor(named: "\(self.nextColor)")
        next.scheduleLabel.text = self.nextPost.value!.scheduleContent
        next.userNameLabel.text = self.nextPost.value?.accountId
        next.locationLabel.text = self.nextPost.value!.address
        next.dateLabel.text = self.nextPost.value!.createTime
        next.contentTextView.text = self.nextPost.value!.content
        self.navigationController?.pushViewController(next, animated: true)
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
