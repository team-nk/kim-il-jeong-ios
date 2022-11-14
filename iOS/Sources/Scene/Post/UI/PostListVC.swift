import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PostListVC: BaseVC {
    var birthDayList: [BirthDay] = []
    var scheduleList: [Schedule] = []
    let dummyList = Dummies()
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
    func setUpTableView() {
        birthTableView.delegate = self
        birthTableView.dataSource = self
        birthTableView.reloadData()

        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.reloadData()
    }
    func addDummyData() {
        birthDayList = [
            dummyList.birthItem1, dummyList.birthItem2,
            dummyList.birthItem3, dummyList.birthItem4
        ]
        scheduleList = [
            dummyList.scheduleItem1, dummyList.scheduleItem2,
            dummyList.scheduleItem3, dummyList.scheduleItem4,
            dummyList.scheduleItem5
        ]
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
        addDummyData()
        setUpTableView()
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
            if birthDayList.count * 90 + scheduleList.count * 80 > 800 {
                $0.height.equalTo(400 + (birthDayList.count + scheduleList.count) * 90)
            } else {
                $0.height.equalTo(900)
            }
        }
        writePostButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(42)
            $0.bottom.equalToSuperview().inset(115)
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
