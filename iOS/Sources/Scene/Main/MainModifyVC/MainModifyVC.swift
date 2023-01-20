import UIKit
import SnapKit
import Then
import MapKit
import RxCocoa
import CoreLocation

class MainModifyVC: BaseVC {
    var address = PublishRelay<String>()
    private let viewModel = MainModifyViewModel()
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    private let planChangeLabel = UILabel().then {
        $0.setLabel(text: "새로운 일정 생성하기",
                    textColor: KimIlJeongAsset.Color.textColor.color,
                    font: UIFont.boldSystemFont(ofSize: 25))
    }
    private let titleTextField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
        $0.placeholder = "일정을 입력하세요"
        $0.textColor = KimIlJeongAsset.Color.strongExplanation.color
    }
    private let titleUnderLine = UIView().then {
        $0.backgroundColor = KimIlJeongAsset.Color.strongExplanation.color
    }
    private let titleTextStateLabel = UILabel().then {
        $0.setLabel(text: "0/100",
                    textColor: KimIlJeongAsset.Color.strongExplanation.color,
                    font: UIFont.systemFont(ofSize: 16, weight: .regular))
        $0.textAlignment = .right
    }
    private let addressLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
        $0.textColor = KimIlJeongAsset.Color.strongExplanation.color
    }
    private let serachLocationButton = UIButton(type: .system).then {
        $0.setTitle("위치 검색", for: .normal)
        $0.setTitleColor(KimIlJeongAsset.Color.textColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    private let setColorLabel = UILabel().then {
        $0.setLabel(text: "색상설정",
                    textColor: KimIlJeongColor.strongExplanation.color,
                    font: UIFont.systemFont(ofSize: 18, weight: .light))
    }
    private let colorStackView = ColorStackView().then {
        $0.axis = .horizontal
    }
    private let allDayScheduleLabel = UILabel().then {
        $0.setLabel(text: "일정이 하루 종일 인가요?",
                    textColor: KimIlJeongColor.strongExplanation.color,
                    font: UIFont.systemFont(ofSize: 18, weight: .light))
    }
    private let allDayScheduleSwitch = UISwitch().then {
        $0.onTintColor = KimIlJeongColor.mainColor.color
        $0.isOn = false
    }
    private let startTimeLabel = UILabel().then {
        $0.setLabel(text: "시작 시간",
                    textColor: KimIlJeongColor.strongExplanation.color,
                    font: UIFont.systemFont(ofSize: 18, weight: .light))
    }
    private let startTimeTextField = UITextField().then {
        $0.setModifyTextField(
            textColor: KimIlJeongColor.textColor.color,
            backGroundColor: KimIlJeongColor.backGroundColor4.color)
    }
    private let endTimeLabel = UILabel().then {
        $0.setLabel(text: "종료 시간",
                    textColor: KimIlJeongColor.strongExplanation.color,
                    font: UIFont.systemFont(ofSize: 18, weight: .light))
    }
    private let endTimeTextField = UITextField().then {
        $0.setModifyTextField(
            textColor: KimIlJeongColor.textColor.color,
            backGroundColor: KimIlJeongColor.backGroundColor4.color)
    }
    private let cencelButton = UIButton(type: .system).then {
        $0.setButton(
            title: "취소하기",
            titleColor: KimIlJeongAsset.Color.textColor.color,
            backgroundColor: KimIlJeongAsset.Color.backGroundColor2.color)
    }
    private let doneButton = UIButton(type: .system).then {
        $0.setButton(
            title: "생성하기",
            titleColor: KimIlJeongAsset.Color.surfaceColor.color,
            backgroundColor: KimIlJeongAsset.Color.mainColor.color)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        address.subscribe(onNext: { [self] in
            addressLabel.text = $0
        }).disposed(by: disposeBag)
    }
    override func bind() {
        let input = MainModifyViewModel.Input(
            content: titleTextField.rx.text.orEmpty.asDriver(), address: address.asDriver(onErrorJustReturn: ""),
            color: colorStackView.color.asDriver(), startTime: startTimeTextField.rx.text.orEmpty.asDriver(),
            endTime: endTimeTextField.rx.text.orEmpty.asDriver(), isAlways: allDayScheduleSwitch.rx.isOn.asDriver(),
            doneButtonDidTap: doneButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)
        output.postScheduleResult.subscribe(onNext: {
            $0 ? self.dismiss(animated: false) {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("reloadData"),
                        object: nil,
                        userInfo: nil)
            } : print("생성 실패")
        }).disposed(by: disposeBag)
        output.content.asObservable()
            .subscribe(onNext: { [self] in
                titleTextStateLabel.textColor = Int($0)! >= 100 ? .red : KimIlJeongColor.strongExplanation.color
                titleTextStateLabel.text = $0 + "/100"
            }).disposed(by: disposeBag)
    }
    override func configureVC() {
        cencelButton.rx.tap
            .subscribe(onNext: { [self] in
                dismiss(animated: true)
            }).disposed(by: disposeBag)
        serachLocationButton.rx.tap.subscribe(onNext: {
            let kakaoZipCodeVC = KakaoZipCodeVC()
            kakaoZipCodeVC.preView = "mainModify"
            kakaoZipCodeVC.modalPresentationStyle = .fullScreen
            self.present(kakaoZipCodeVC, animated: true)
        }).disposed(by: disposeBag)
        startDatePicker.rx.date.subscribe(onNext: {
            self.startTimeTextField.text = $0.dateFormate()
        }).disposed(by: disposeBag)
        endDatePicker.rx.date.subscribe(onNext: {
            self.endTimeTextField.text = $0.dateFormate()
        }).disposed(by: disposeBag)
        startTimeTextField.setToolBar(width: self.bound.width, disposeBag: disposeBag, datePicker: startDatePicker )
        endTimeTextField.setToolBar(width: self.bound.width, disposeBag: disposeBag, datePicker: endDatePicker)
    }
    override func addView() {
        [
            planChangeLabel,
            titleTextField,
            titleUnderLine,
            titleTextStateLabel,
            addressLabel,
            serachLocationButton,
            setColorLabel,
            colorStackView,
            allDayScheduleLabel,
            allDayScheduleSwitch,
            startTimeLabel,
            startTimeTextField,
            endTimeLabel,
            endTimeTextField,
            cencelButton,
            doneButton
        ].forEach {view.addSubview($0)}
    }
    // swiftlint:disable function_body_length
    override func setLayout() {
        planChangeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(planChangeLabel.snp.bottom).offset(35)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(100)
        }
        titleUnderLine.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        titleTextStateLabel.snp.makeConstraints {
            $0.top.equalTo(planChangeLabel.snp.bottom).offset(35)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(29)
        }
        addressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(titleUnderLine.snp.bottom).offset(35)
            $0.trailing.equalToSuperview().inset(120)
            $0.height.equalTo(32)
        }
        serachLocationButton.snp.makeConstraints {
            $0.top.equalTo(titleUnderLine.snp.bottom).offset(35)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(32)
        }
        setColorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(addressLabel.snp.bottom).offset(35)
            $0.height.equalTo(32)
        }
        colorStackView.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(35)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.equalTo(157)
            $0.height.equalTo(25)
        }
        allDayScheduleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(setColorLabel.snp.bottom).offset(35)
            $0.height.equalTo(32)
        }
        allDayScheduleSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(colorStackView.snp.bottom).offset(39)
            $0.height.equalTo(31)
        }
        startTimeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(allDayScheduleLabel.snp.bottom).offset(35)
            $0.height.equalTo(32)
        }
        startTimeTextField.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(allDayScheduleSwitch.snp.bottom).offset(35)
            $0.height.equalTo(34)
            $0.width.equalTo(150)
        }
        endTimeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(startTimeLabel.snp.bottom).offset(35)
            $0.height.equalTo(32)
        }
        endTimeTextField.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(startTimeTextField.snp.bottom).offset(35)
            $0.height.equalTo(34)
            $0.width.equalTo(150)
        }
        cencelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo((view.frame.width-60)/2)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
        doneButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo((view.frame.width-60)/2)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
}
