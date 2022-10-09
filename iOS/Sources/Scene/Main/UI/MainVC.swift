import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import FSCalendar

class MainVC: BaseVC<MainReactor> {
    private let kimIlJeongLabel = UILabel().then{
        $0.textColor = KimIlJeongColor.textColor.color
        $0.text = "Kim il jeong"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
    }
    private let calendarLabel = UILabel().then{
        $0.textColor = KimIlJeongColor.mainColor.color
        $0.text = "Calendar"
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    private let calendarBackground = UIView().then {
        $0.backgroundColor = KimIlJeongColor.surfaceColor.color
        $0.layer.cornerRadius = 32
    }
    private let fsCalendar = FSCalendar().then {

        //언어 한국어로 변경
        $0.locale = Locale(identifier: "en_US")


        //상단 헤더 뷰 관련
        $0.headerHeight = 34 // YYYY년 M월 표시부 영역 높이
        $0.weekdayHeight = 34 // 날짜 표시부 행의 높이
        $0.appearance.headerMinimumDissolvedAlpha = 0.0 //헤더 좌,우측 흐릿한 글씨 삭제
        $0.appearance.headerDateFormat = "YYYY년 M월" //날짜(헤더) 표시 형식
        $0.appearance.headerTitleColor = KimIlJeongColor.textColor.color //2021년 1월(헤더) 색
        $0.appearance.headerTitleFont = .systemFont(ofSize: 15, weight: .regular) //타이틀 폰트 크기


        //캘린더(날짜 부분) 관련
        $0.backgroundColor = KimIlJeongColor.surfaceColor.color // 배경색
        $0.appearance.weekdayTextColor = KimIlJeongColor.textColor.color //요일(월,화,수..) 글씨 색
        $0.appearance.borderSelectionColor = KimIlJeongColor.mainColor.color //선택 된 날의 동그라미 색
        $0.appearance.titleSelectionColor = KimIlJeongColor.textColor.color
        $0.appearance.selectionColor = UIColor.clear
        $0.appearance.titleWeekendColor = KimIlJeongColor.textColor.color //주말 날짜 색
        $0.appearance.titleDefaultColor = KimIlJeongColor.textColor.color //기본 날짜 색
        $0.scrollEnabled = false //스크롤 여부


        //오늘 날짜(Today) 관련
        $0.appearance.titleTodayColor = KimIlJeongColor.surfaceColor.color //Today에 표시되는 특정 글자색
        $0.appearance.todayColor = KimIlJeongColor.mainColor.color //Today에 표시되는 선택 전 동그라미 색
        $0.appearance.todaySelectionColor = .none  //Today에 표시되는 선택 후 동그라미 색


        // day 폰트 설정
        $0.appearance.titleFont = .systemFont(ofSize: 13, weight: .medium)
    }
    private let gotoTomorrow = UIButton().then {
        $0.setImage(UIImage(named: "chevron-right"), for: .normal)
    }
    private let gotoYesterday = UIButton().then {
        $0.setImage(UIImage(named: "chevron-left"), for: .normal)
    }
    
    let calendar = Calendar.current
    lazy var currentPage = fsCalendar.currentPage
    lazy var today: Date = {
        return Date()
    }()

    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage)!
        self.fsCalendar.setCurrentPage(self.currentPage, animated: true)
    }
    
    override func addView() {
        self.view.backgroundColor = KimIlJeongColor.backGroundColor.color
        [
            kimIlJeongLabel,
            calendarLabel,
            calendarBackground,
            fsCalendar,
            gotoTomorrow,
            gotoYesterday
        ].forEach {
            view.addSubview($0)
        }
        gotoTomorrow.addTarget(self, action: #selector(changeAfterDate), for: .touchUpInside)
        gotoYesterday.addTarget(self, action: #selector(changeBeforeDate), for: .touchUpInside)
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
        calendarBackground.snp.makeConstraints {
            $0.top.equalTo(calendarLabel.snp.bottom).offset(21)
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(300)
        }
        gotoTomorrow.snp.makeConstraints {
            $0.top.equalTo(fsCalendar.snp.top).inset(4)
            $0.right.equalToSuperview().inset(100)
            $0.width.height.equalTo(30)
        }
        gotoYesterday.snp.makeConstraints {
            $0.top.equalTo(fsCalendar.snp.top).inset(4)
            $0.left.equalToSuperview().inset(100)
            $0.width.height.equalTo(30)
        }
        fsCalendar.snp.makeConstraints {
            $0.edges.equalTo(calendarBackground).inset(16)
        }
        
        /// shadow가 있으려면 layer.borderWidth 값이 필요
        calendarBackground.layer.borderWidth = 0
        /// 테두리 밖으로 contents가 있을 때, 마스킹(true)하여 표출안되게 할것인지 마스킹을 off(false)하여 보일것인지 설정
        calendarBackground.layer.masksToBounds = false
        /// shadow 색상
        calendarBackground.layer.shadowColor = UIColor.black.cgColor
        /// 현재 shadow는 view의 layer 테두리와 동일한 위치로 있는 상태이므로 offset을 통해 그림자를 이동시켜야 표출
        calendarBackground.layer.shadowOffset = CGSize(width: 0, height: 20)
        /// shadow의 투명도 (0 ~ 1)
        calendarBackground.layer.shadowOpacity = 0.15
        /// shadow의 corner radius
        calendarBackground.layer.shadowRadius = 32
    }
    @objc fileprivate func changeBeforeDate() {
        moveMonth(next: false)
    }
    @objc fileprivate func changeAfterDate() {
        moveMonth(next: true)
    }
}
extension MainVC : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
}