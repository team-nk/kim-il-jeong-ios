import UIKit
import SnapKit
import Then
import MapKit
import RxCocoa
import CoreLocation
// swiftlint:disable type_body_length
class MainEditModifyVC: BaseVC {
    private let viewModel = ModifyViewModel()
    private let planChangeLabel = UILabel().then {
        $0.text = "일정 변경하기"
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.textColor = KimIlJeongAsset.Color.textColor.color
    }
    private let titleTextField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
        $0.placeholder = "일정을 입력하세요"
        $0.text = "스타벅스 인수 계약"
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
    private let addressLabel = UILabel().then {
        $0.text = "대전광역시 둔산동 갤러리아..."
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
    private let colorStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    private let redColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongColor.errorColor.color
        $0.layer.cornerRadius = 12.5
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let checkImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig.self)
        $0.setImage(checkImage, for: .normal)
        $0.tintColor = KimIlJeongColor.surfaceColor.color
    }
    private let blueColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongColor.mainColor.color
        $0.layer.cornerRadius = 12.5
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let checkImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig.self)
        $0.setImage(checkImage, for: .normal)
        $0.tintColor = KimIlJeongColor.surfaceColor.color
    }
    private let yellowColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongColor.yellowColor.color
        $0.layer.cornerRadius = 12.5
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let checkImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig.self)
        $0.setImage(checkImage, for: .normal)
        $0.tintColor = KimIlJeongColor.surfaceColor.color
    }
    private let greenColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongColor.greenColor.color
        $0.layer.cornerRadius = 12.5
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let checkImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig.self)
        $0.setImage(checkImage, for: .normal)
        $0.tintColor = KimIlJeongColor.surfaceColor.color
    }
    private let purpleColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongColor.purpleColor.color
        $0.layer.cornerRadius = 12.5
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let checkImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig.self)
        $0.setImage(checkImage, for: .normal)
        $0.tintColor = KimIlJeongColor.surfaceColor.color
    }
    private let allDayScheduleLabel = UILabel().then {
        $0.text = "일정이 하루 종일 인가요?"
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
    }
    private let allDayScheduleSwitch = UISwitch().then {
        $0.onTintColor = KimIlJeongColor.mainColor.color
    }
    private let startTimeLabel = UILabel().then {
        $0.text = "시작 시간"
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
    }
    private let startTimeTextField = UITextField().then {
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
    private let endTimeTextField = UITextField().then {
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
        $0.setTitle("Cancel", for: .normal)
        $0.setTitleColor(KimIlJeongAsset.Color.textColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    private let doneButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.mainColor.color
        $0.layer.cornerRadius = 10
        $0.setTitle("Done", for: .normal)
        $0.setTitleColor(KimIlJeongAsset.Color.surfaceColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    override func viewDidLoad() {
        if #available(iOS 16.0, *) {
            if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [
                    .custom { _ in
                        return 600
                    }
                ]
                presentationController.preferredCornerRadius = 32
            }
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        setTextField()
    }
    override func bind() {
        let input = ModifyViewModel.Input(titleText: titleTextField.rx.text.orEmpty.asDriver())
        let output = viewModel.transform(input)
        output.title.asObservable()
            .subscribe(onNext: { [self] in
                titleTextStateLabel.textColor = Int($0)! >= 100 ? .red : KimIlJeongColor.strongExplanation.color
                titleTextStateLabel.text = $0 + "/100"
            }).disposed(by: disposeBag)
    }
    private func setTextField() {
        titleTextField.rx.text.orEmpty
            .asObservable()
            .subscribe(onNext: {
                self.titleTextStateLabel.text = "\($0.count)/100"
            }).disposed(by: disposeBag)
    }
    override func configureVC() {
        cencelButton.rx.tap
            .subscribe(onNext: { [self] in
                dismiss(animated: true)
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
        [
            redColorButton,
            blueColorButton,
            yellowColorButton,
            greenColorButton,
            purpleColorButton
        ].forEach {colorStackView.addSubview($0)}
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
        redColorButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        blueColorButton.snp.makeConstraints {
            $0.leading.equalTo(redColorButton.snp.trailing).offset(8)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        yellowColorButton.snp.makeConstraints {
            $0.leading.equalTo(blueColorButton.snp.trailing).offset(8)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        greenColorButton.snp.makeConstraints {
            $0.leading.equalTo(yellowColorButton.snp.trailing).offset(8)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        purpleColorButton.snp.makeConstraints {
            $0.leading.equalTo(greenColorButton.snp.trailing).offset(8)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
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
