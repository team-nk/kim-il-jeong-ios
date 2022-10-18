import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PostListVC: BaseVC<PostListVCReactor> {
    var birthDayList: [BirthDay] = []
    var scheduleList: [Schedule] = []
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
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
        $0.register(BirthDayCell.self, forCellReuseIdentifier: "\(BirthDayCell.id)")
        $0.rowHeight = 90
        $0.separatorStyle = .none
        $0.backgroundColor = KimIlJeongColor.backGroundColor2.color
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    private let scheduleTableView = ContentWrappingTableView().then {
        $0.register(ScheduleCell.self, forCellReuseIdentifier: "\(ScheduleCell.id)")
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
            postLabel
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
        // BirthDaySection
        let birthItem1 = BirthDay.self(username: "Daehee", birthDate: "2022-08-22")
        let birthItem2 = BirthDay.self(username: "younhee0824", birthDate: "2022-08-24")
        let birthItem3 = BirthDay.self(username: "Kimdaehee0824", birthDate: "2022-08-24")
        let birthItem4 = BirthDay.self(username: "dlsgP08", birthDate: "2022-08-26")
        birthDayList = [birthItem1, birthItem2, birthItem3, birthItem4]
        print(birthDayList)
        // PostListSection
        let scheduleItem1 = Schedule.self(
            color: "MainColor", title: "기능정의서 구체화",
            content: "재미있는 노션 공부 시간", owner: "wkdtjrdus05",
            date: "2022-08-02", location: "광주광역시 농성동 농성제일파크"
        )
        let scheduleItem2 = Schedule.self(
            color: "ErrorColor", title: "자치 회의를 시작하려 합니다",
            content: "학교 자치 회의", owner: "Kimdaehee0824",
            date: "2022-12-22", location: "대전광역시 유성구 가정북로 76"
        )
        let scheduleItem3 = Schedule.self(
            color: "MainColor", title: "국군 의병 선서식 참여하셔야 합니다.",
            content: "의병 선서식", owner: "ROKA-ARMY",
            date: "2024-08-02", location: "충청남도 천안시 현충원 메인광장"
        )
        let scheduleItem4 = Schedule.self(
            color: "MainColor", title: "국군 의병 선서식 참여하셔야 합니다.",
            content: "의병 선서식", owner: "ROKA-ARMY",
            date: "2024-08-02", location: "충청남도 천안시 현충원 메인광장"
        )
        scheduleList = [scheduleItem1, scheduleItem2, scheduleItem3, scheduleItem4]
        print(scheduleList)
    }
    override func configureVC() {
        super.configureVC()
        scrollView.contentInsetAdjustmentBehavior = .never
        addDummyData()
        setUpTableView()
        addView()
        setLayout()
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
                print("what")
                $0.height.equalTo(700 + (birthDayList.count + scheduleList.count) * 90)
            } else {
                print("엥")
                $0.height.equalTo(800)
            }
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
            if let birthCell = tableView.dequeueReusableCell(withIdentifier: "\(BirthDayCell.id)", for: indexPath) as? BirthDayCell {
                birthCell.configureVC()
                birthCell.congratulationsLabel.text = "\(birthDayList[indexPath.row].username)님의 생일이에요!"
                birthCell.dateLabel.text = "\(birthDayList[indexPath.row].birthDate)"
                birthCell.selectionStyle = .none
                return birthCell
            } else {
                return UITableViewCell()
            }
        case scheduleTableView:
            if let scheduleCell = scheduleTableView.dequeueReusableCell(withIdentifier: "\(ScheduleCell.id)", for: indexPath) as? ScheduleCell {
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
