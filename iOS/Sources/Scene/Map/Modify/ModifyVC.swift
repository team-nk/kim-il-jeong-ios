import UIKit
import SnapKit
import Then
import MapKit
import RxCocoa
import CoreLocation

class ModifyVC: BaseVC {
    var scheduleId = 0
    private let viewModel = ModifyViewModel()
    private let planChangeLabel = UILabel().then {
        $0.text = "일정 변경하기"
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.textColor = KimIlJeongAsset.Color.textColor.color
    }
    let titleTextField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
        $0.placeholder = "일정을 입력하세요"
        $0.textColor = KimIlJeongAsset.Color.strongExplanation.color
    }
    private let titleUnderLine = UIView().then {
        $0.backgroundColor = KimIlJeongAsset.Color.strongExplanation.color
    }
    private let titleTextStateLabel = UILabel().then {
        $0.text = "0/100"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = KimIlJeongAsset.Color.strongExplanation.color
        $0.textAlignment = .right
    }
    let addressLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
        $0.textColor = KimIlJeongAsset.Color.strongExplanation.color
    }
    private let serachLocationButton = UIButton(type: .system).then {
        $0.setTitle("위치 검색", for: .normal)
        $0.setTitleColor(KimIlJeongAsset.Color.textColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    private let setColorLabel = UILabel().then {
        $0.text = "색상설정"
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
    }
    let colorStackView = ColorStackView().then {
        $0.axis = .horizontal
    }
    private let allDayScheduleLabel = UILabel().then {
        $0.text = "일정이 하루 종일 인가요?"
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
    }
    let allDayScheduleSwitch = UISwitch().then {
        $0.onTintColor = KimIlJeongColor.mainColor.color
        $0.isOn = false
    }
    private let startTimeLabel = UILabel().then {
        $0.text = "시작 시간"
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
    }
    let startTimeTextField = UITextField().then {
        $0.text = "2022-05-08"
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = KimIlJeongColor.backGroundColor4.color
        $0.textAlignment = .center
    }
    private let endTimeLabel = UILabel().then {
        $0.text = "시작 시간"
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
    }
    let endTimeTextField = UITextField().then {
        $0.text = "2022-05-09"
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = KimIlJeongColor.backGroundColor4.color
        $0.textAlignment = .center
    }
    private let cencelButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.backGroundColor2.color
        $0.layer.cornerRadius = 10
        $0.setTitle("취소하기", for: .normal)
        $0.setTitleColor(KimIlJeongAsset.Color.textColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    private let doneButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.mainColor.color
        $0.layer.cornerRadius = 10
        $0.setTitle("변경하기", for: .normal)
        $0.setTitleColor(KimIlJeongAsset.Color.surfaceColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }

    override func bind() {
        let input = ModifyViewModel.Input(
            scheduleId: scheduleId,
            content: titleTextField.rx.text.orEmpty.asDriver(),
            address: addressLabel.text ?? ""
            ,
            color: colorStackView.color.asDriver(),
            startTime: startTimeTextField.rx.text.orEmpty.asDriver(),
            endTime: endTimeTextField.rx.text.orEmpty.asDriver(),
            isAlways: allDayScheduleSwitch.rx.isOn.asDriver(),
            doneButtonDidTap: doneButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)
        output.putScheduleResult.subscribe(onNext: { _ in
            self.dismiss(animated: false) {
                NotificationCenter.default.post(
                    name: NSNotification.Name("reloadData"),
                    object: nil,
                    userInfo: nil
                )
            }
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
            kakaoZipCodeVC.modalPresentationStyle = .fullScreen
            self.present(kakaoZipCodeVC, animated: true)
        }).disposed(by: disposeBag)
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
            $0.width.equalTo(121)
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
            $0.width.equalTo(121)
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
