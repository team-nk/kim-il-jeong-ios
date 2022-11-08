import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PostListVC: BaseVC {
    private var birthDayList: [BirthDay] = []
    private var scheduleList: [Schedule] = []
    private let dummyList = Dummies()
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
    private let birthTableView = ContentWrappingTableView().then {
        $0.register(BirthDayCell.self, forCellReuseIdentifier: "BirthDayCell")
        $0.rowHeight = 90
        $0.separatorStyle = .none
        $0.backgroundColor = KimIlJeongColor.backGroundColor2.color
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    private let scheduleTableView = ContentWrappingTableView().then {
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
    func addDummyData() {
        birthDayList = [
            dummyList.birthItem1, dummyList.birthItem2,
            dummyList.birthItem3, dummyList.birthItem4
        ]
        scheduleList = [
            dummyList.scheduleItem1, dummyList.scheduleItem2,
            dummyList.scheduleItem3, dummyList.scheduleItem4
        ]
    }
    override func configureVC() {
        scrollView.contentInsetAdjustmentBehavior = .never
        addDummyData()
        setUpTableView()
        writePostButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?
                    .pushViewController(NewPostVC(reactor: NewPostVCReactor()), animated: true)
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
                $0.height.equalTo(700 + (birthDayList.count + scheduleList.count) * 90)
            } else {
                $0.height.equalTo(800)
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

extension PostListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case birthTableView:
            return birthDayList.count

        case scheduleTableView:
            return scheduleList.count

        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case birthTableView:
            if let birthCell = tableView.dequeueReusableCell(withIdentifier: "BirthDayCell",
                                                             for: indexPath) as? BirthDayCell {
                birthCell.configureVC()
                birthCell.congratulationsLabel.text = "\(birthDayList[indexPath.row].username)님의 생일이에요!"
                birthCell.dateLabel.text = "\(birthDayList[indexPath.row].birthDate)"
                birthCell.selectionStyle = .none
                return birthCell
            } else {
                return UITableViewCell()
            }
        case scheduleTableView:
            if let scheduleCell = scheduleTableView.dequeueReusableCell(withIdentifier: "ScheduleCell",
                                                                        for: indexPath) as? ScheduleCell {
                scheduleCell.configureVC()
                scheduleCell.scheduleTitle.text = "\(scheduleList[indexPath.row].title)"
                scheduleCell.scheduleOwner.text = "\(scheduleList[indexPath.row].owner)"
                scheduleCell.scheduleContent.text = "\(scheduleList[indexPath.row].content)"
                scheduleCell.scheduleDate.text = "\(scheduleList[indexPath.row].date)"
                scheduleCell.scheduleLocation.text = "\(scheduleList[indexPath.row].location)"
                scheduleCell.selectionStyle = .none
                return scheduleCell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}
