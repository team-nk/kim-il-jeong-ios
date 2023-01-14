import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PostListVC: BaseVC {
    private let getPosts = BehaviorRelay<Void>(value: ())
    private let viewModel = PostListVM()
    private let nextID = BehaviorRelay<Int>(value: 0)
    var birthUserCount = Int()
    var postsCount = Int()
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let writePostButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongColor.surface2.color
        $0.setImage(UIImage(named: "Pencil"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 0.15
        $0.layer.shadowRadius = 3
        $0.setTitle("글 작성하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
    }
    private let logoLabel = UILabel().then {
        $0.text = "Kim il jeong"
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 34, weight: .bold)
    }
    private let postLabel = UILabel().then {
        $0.text = "Post"
        $0.textColor = KimIlJeongColor.mainColor.color
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    let birthTableView = ContentWrappingTableView().then {
        $0.register(BirthDayCell.self, forCellReuseIdentifier: "BirthDayCell")
        $0.rowHeight = 90
        $0.separatorStyle = .none
        $0.backgroundColor = KimIlJeongColor.backGroundColor2.color
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    let scheduleTableView = ContentWrappingTableView().then {
        $0.register(ScheduleCell.self, forCellReuseIdentifier: "ScheduleCell")
        $0.rowHeight = 80
        $0.separatorInset.left = 16
        $0.separatorInset.right = 15
        $0.backgroundColor = KimIlJeongColor.backGroundColor2.color
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    private func updateConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            if birthUserCount * 90 + postsCount * 80 > 800 {
                $0.height.equalTo((birthUserCount + postsCount) * 90)
            } else {
                $0.height.equalTo(900)
            }
        }
    }
    // swiftlint:disable function_body_length
    override func bind() {
        let input = PostListVM.Input(
            getLists: getPosts.asDriver(onErrorJustReturn: ()),
            selectedIndex: scheduleTableView.rx.itemSelected.asSignal()
        )
        let output = viewModel.transform(input)
        output.birthUsers.bind(to: birthTableView.rx.items(
            cellIdentifier: "BirthDayCell",
            cellType: BirthDayCell.self)) { _, items, cell in
                cell.congratulationsLabel.text = "\(items.accountId)님의 생일이에요!"
                cell.dateLabel.text = items.birthday
                cell.selectionStyle = .none
                self.birthUserCount += 1
                self.updateConstraints()
            }.disposed(by: disposeBag)
        output.posts.bind(to: scheduleTableView.rx.items(
            cellIdentifier: "ScheduleCell",
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
                    print("ColorEmpty1")
                }
                cell.selectionStyle = .none
                self.postsCount += 1
                self.updateConstraints()
            }.disposed(by: disposeBag)
        output.postID
            .subscribe(onNext: {
                self.nextID.accept($0)
            }).disposed(by: disposeBag)
        scheduleTableView.rx.itemSelected
            .subscribe(onNext: { _ in
                self.cellDidTap()
            }).disposed(by: disposeBag)
    }
    private func cellDidTap() {
        let next = PostVC()
        next.postID.accept(nextID.value)
        self.navigationController?.pushViewController(next, animated: true)
    }
    override func addView() {
        [
            scrollView,
            logoLabel,
            postLabel,
            writePostButton
        ]
            .forEach {
                view.addSubview($0)
            }
        scrollView.addSubview(contentView)
        [
            birthTableView,
            scheduleTableView
        ]
            .forEach {
                contentView.addSubview($0)
            }
    }
    override func configureVC() {
        scrollView.contentInsetAdjustmentBehavior = .never
        writePostButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?
                    .pushViewController(NewPostVC(), animated: true)
            }).disposed(by: disposeBag)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(150)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            if birthUserCount * 90 + postsCount * 80 > 800 {
                $0.height.equalTo(400 + (birthUserCount + postsCount) * 90)
            } else {
                $0.height.equalTo(900)
            }
        }
        writePostButton.snp.makeConstraints {
            $0.trailing.equalTo(scheduleTableView.snp.trailing).offset(-15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(27)
            $0.width.equalTo(141)
            $0.height.equalTo(56)
        }
        logoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(69)
            $0.leading.equalToSuperview().inset(38)
            $0.height.equalTo(44)
        }
        postLabel.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(0)
            $0.leading.equalToSuperview().inset(38)
            $0.height.equalTo(32)
        }
        birthTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(23)
            $0.trailing.equalToSuperview().inset(24)
        }
        scheduleTableView.snp.makeConstraints {
            $0.top.equalTo(birthTableView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(23)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
