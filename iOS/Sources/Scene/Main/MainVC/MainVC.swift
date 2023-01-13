import FSCalendar
import RxSwift
import RxCocoa
import UIKit

class MainVC: BaseVC {
    private let refresh = PublishRelay<Void>()
    private let viewModel = MainViewModel()
    private let viewAppear = PublishRelay<Void>()
    private let kimIlJeongLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.textColor.color
        $0.text = "Kim il jeong"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
    }
    private let calendarLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.mainColor.color
        $0.text = "Calendar"
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    private let calendarBackgroundView = UIView().then {
        $0.backgroundColor = KimIlJeongColor.surfaceColor.color
        $0.layer.cornerRadius = 32
    }
    private let fsCalendar = FSCalendar().then {
        // 언어 영어로 변경
        $0.locale = Locale(identifier: "en_US")
        // 상단 헤더 뷰 관련
        $0.headerHeight = 34 // YYYY년 M월 표시부 영역 높이
        $0.weekdayHeight = 34 // 날짜 표시부 행의 높이
        $0.appearance.headerMinimumDissolvedAlpha = 0.0 // 헤더 좌,우측 흐릿한 글씨 삭제
        $0.appearance.headerDateFormat = "YYYY년 M월" // 날짜(헤더) 표시 형식
        $0.appearance.headerTitleColor = KimIlJeongColor.textColor.color // 2021년 1월(헤더) 색
        $0.appearance.headerTitleFont = .systemFont(ofSize: 15, weight: .regular) // 타이틀 폰트 크기
        // 캘린더(날짜 부분) 관련
        $0.backgroundColor = KimIlJeongColor.surfaceColor.color // 배경색
        $0.appearance.weekdayTextColor = KimIlJeongColor.textColor.color // 요일(월,화,수..) 글씨 색
        $0.appearance.borderSelectionColor = KimIlJeongColor.mainColor.color // 선택 된 날의 동그라미 색
        $0.appearance.titleSelectionColor = KimIlJeongColor.textColor.color
        $0.appearance.selectionColor = UIColor.clear
        $0.appearance.titleWeekendColor = KimIlJeongColor.textColor.color // 주말 날짜 색
        $0.appearance.titleDefaultColor = KimIlJeongColor.textColor.color // 기본 날짜 색
        $0.scrollEnabled = true // 스크롤 여부
        // 오늘 날짜(Today) 관련
        $0.appearance.titleTodayColor = KimIlJeongColor.surfaceColor.color // Today에 표시되는 특정 글자색
        $0.appearance.todayColor = KimIlJeongColor.mainColor.color // Today에 표시되는 선택 전 동그라미 색
        $0.appearance.todaySelectionColor = .none  // Today에 표시되는 선택 후 동그라미 색
        // day 폰트 설정
        $0.appearance.titleFont = .systemFont(ofSize: 13, weight: .medium)
    }
    private let gotoTomorrowButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_right_chevron"), for: .normal)
    }
    private let gotoYesterdayButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_left_chevron"), for: .normal)
    }
    let calendar = Calendar.current
    lazy var currentPage = fsCalendar.currentPage
    lazy var today: Date = {
        return Date()
    }()
    private let toDayDoLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.textColor.color
        $0.text = "5월 8일 일정"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    private let plusToDoButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = KimIlJeongColor.textColor.color
    }
    private let dividedLine = UIView().then {
        $0.backgroundColor = KimIlJeongColor.description.color
    }
    private let toDayDoTableView = UITableView().then {
        $0.rowHeight = 49
        $0.backgroundColor = .clear
        $0.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.cellID)
        $0.separatorStyle = .none
    }
    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        guard let page = calendar.date(byAdding: dateComponents, to: self.currentPage) else { return }
        self.currentPage = page
        self.fsCalendar.setCurrentPage(self.currentPage, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        refresh.accept(())
    }
    override func bind() {
        let input = MainViewModel.Input(refresh: refresh.asSignal(), viewAppear: viewAppear.asSignal())
        let output = viewModel.transform(input)
        output.refreshResult.subscribe(onNext: { [self] in
            switch $0 {
            case true:
                viewAppear.accept(())
            default:
                print("실패")
                let loginVC = BaseNC(rootViewController: LoginVC())
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
        }).disposed(by: disposeBag)
        output.mySchedulesList
            .bind(to: toDayDoTableView.rx.items(
                cellIdentifier: ToDoTableViewCell.cellID,
                cellType: ToDoTableViewCell.self)) { _, item, cell in
                    let nowDate = item.end_time
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "ko_KR")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let str = dateFormatter.date(from: nowDate)
                    let myDateFormatter = DateFormatter()
                    myDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let time = myDateFormatter.string(from: str ?? Date())
                    cell.dateLabel.text = time
                    cell.toDoTitle.text = item.content
                    cell.colorDot.tintColor = item.color.colorDistinction()
                    cell.selectionStyle = .none
                    cell.backgroundColor = .clear
                }.disposed(by: disposeBag)
    }
    override func configureVC() {
        gotoTomorrowButton.rx.tap
            .bind {
                self.moveMonth(next: true)
            }
            .disposed(by: disposeBag)
        gotoYesterdayButton.rx.tap
            .bind {
                self.moveMonth(next: false)
            }
            .disposed(by: disposeBag)
        plusToDoButton.rx.tap
            .subscribe(onNext: { _ in
                let mainModifyVC = MainModifyVC()
                if #available(iOS 16.0, *) {
                    if let sheet = mainModifyVC.sheetPresentationController {
                        let id = UISheetPresentationController.Detent.Identifier("frist")
                        let detent = UISheetPresentationController.Detent.custom(identifier: id) { _ in
                            return 700
                        }
                        sheet.detents = [detent]
                        sheet.preferredCornerRadius = 32
                        self.present(mainModifyVC, animated: true)
                    }
                    mainModifyVC.isModalInPresentation = true
                }
            }).disposed(by: disposeBag)
    }
    override func addView() {
        toDayDoTableView.delegate = self
        self.view.backgroundColor = KimIlJeongColor.backGroundColor.color
        [
            kimIlJeongLabel,
            calendarLabel,
            calendarBackgroundView,
            fsCalendar,
            gotoTomorrowButton,
            gotoYesterdayButton,
            toDayDoLabel,
            plusToDoButton,
            dividedLine,
            toDayDoTableView
        ].forEach {
            view.addSubview($0)
        }
    }
    override func setLayout() {
        kimIlJeongLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(41)
            $0.topMargin.equalTo(20)
        }
        calendarLabel.snp.makeConstraints {
            $0.top.equalTo(kimIlJeongLabel.snp.bottom).inset(0)
            $0.leftMargin.equalTo(41)
        }
        calendarBackgroundView.snp.makeConstraints {
            $0.top.equalTo(calendarLabel.snp.bottom).offset(21)
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(300)
        }
        gotoTomorrowButton.snp.makeConstraints {
            $0.top.equalTo(fsCalendar.snp.top).inset(4)
            $0.right.equalToSuperview().inset(100)
            $0.width.height.equalTo(30)
        }
        gotoYesterdayButton.snp.makeConstraints {
            $0.top.equalTo(fsCalendar.snp.top).inset(4)
            $0.left.equalToSuperview().inset(100)
            $0.width.height.equalTo(30)
        }
        fsCalendar.snp.makeConstraints {
            $0.edges.equalTo(calendarBackgroundView).inset(16)
        }
        toDayDoLabel.snp.makeConstraints {
            $0.top.equalTo(calendarBackgroundView.snp.bottom).offset(33)
            $0.left.equalToSuperview().inset(41)
        }
        plusToDoButton.snp.makeConstraints {
            $0.top.equalTo(calendarBackgroundView.snp.bottom).offset(33)
            $0.right.equalToSuperview().inset(41)
        }
        dividedLine.snp.makeConstraints {
            $0.top.equalTo(toDayDoLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(41)
            $0.height.equalTo(1)
        }
        toDayDoTableView.snp.makeConstraints {
            $0.top.equalTo(dividedLine.snp.bottom).inset(-7)
            $0.left.right.equalToSuperview().inset(41)
            $0.bottom.equalToSuperview()
        }
        // shadow가 있으려면 layer.borderWidth 값이 필요
        calendarBackgroundView.layer.borderWidth = 0
        // 테두리 밖으로 contents가 있을 때, 마스킹(true)하여 표출안되게 할것인지 마스킹을 off(false)하여 보일것인지 설정
        calendarBackgroundView.layer.masksToBounds = false
        // shadow 색상
        calendarBackgroundView.layer.shadowColor = UIColor.black.cgColor
        // 현재 shadow는 view의 layer 테두리와 동일한 위치로 있는 상태이므로 offset을 통해 그림자를 이동시켜야 표출
        calendarBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 20)
        // shadow의 투명도 (0 ~ 1)
        calendarBackgroundView.layer.shadowOpacity = 0.15
        // shadow의 corner radius
        calendarBackgroundView.layer.shadowRadius = 32
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailMainVC = DetailMainVC()
        self.present(detailMainVC, animated: true, completion: nil)
    }
}
