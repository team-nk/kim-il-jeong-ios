import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class MyBirthSheetVC: BaseVC {
    private let willSendRequest = BehaviorRelay<Void>(value: ())
    private let viewModel = MyBirthSheetVM()
    let datePicker = UIDatePicker()
    private let inputGuideLabel = UILabel().then {
        $0.text = "생년월일을 입력해 주세요."
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 25.08, weight: .bold)
    }
    private let usageGuideLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "생년월일은 게시판 이용시 사용됩니다. 그 외에는 사용하지 않으며 생일 당일에 자동으로 생일 게시물이 생성됩니다."
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = .systemFont(ofSize: 13, weight: .regular)
    }
    private let selectionGuideLabel = UILabel().then {
        $0.text = "생년월일을 선택하세요"
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    private let datePickerField = UITextField().then {
//        $0.backgroundColor = KimIlJeongColor.cellBackGroundColor.color.withAlphaComponent(0.5)
//        $0.layer.cornerRadius = 8
//        $0.placeholder = "ex) 2022-05-09"
//        $0.textColor = KimIlJeongColor.strongExplanation.color
//        $0.textAlignment = .center
//        $0.font = .systemFont(ofSize: 17, weight: .regular)
//        $0.addPaddingToTextField(leftSize: 10, rightSize: 10)
        $0.addPaddingToTextField(leftSize: 15, rightSize: 15)
        $0.setModifyTextField(
            textColor: KimIlJeongColor.strongExplanation.color,
            backGroundColor: KimIlJeongColor.cellBackGroundColor.color.withAlphaComponent(0.5))
    }
    private let cancelButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .clear
        $0.setTitle("취소하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18.48, weight: .bold)
    }
    private let inputButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = KimIlJeongColor.mainColor.color
        $0.setTitle("입력하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.surfaceColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18.48, weight: .bold)
    }
    override func bind() {
        inputButton.rx.tap
            .subscribe(onNext: {
                let input = MyBirthSheetVM.Input(
                    buttonDidTap: self.willSendRequest.asDriver(),
                    birthDate: self.datePickerField.rx.text.orEmpty.asDriver())
                let output = self.viewModel.transform(input)
                output.postResult
                    .subscribe(onNext: {
                        print($0)
                    }).disposed(by: self.disposeBag)
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    override func addView() {
        if #available(iOS 16.0, *) {
            if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [
                    .custom { _ in
                        return 290
                    }
                ]
                presentationController.preferredCornerRadius = 20
            }
        } else { /*Fallback on earlier versions*/ }
        [
            inputGuideLabel,
            usageGuideLabel,
            selectionGuideLabel,
            datePickerField,
            cancelButton,
            inputButton
        ] .forEach {
            view.addSubview($0)
        }
    }
    override func configureVC() {
        view.backgroundColor = KimIlJeongColor.surfaceColor.color
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        datePicker.rx.date
            .subscribe(onNext: {
                self.datePickerField.text = $0.birthDateFormat()
            }).disposed(by: disposeBag)
        datePickerField.setBirthDayPicker(width: self.bound.width, disposeBag: disposeBag, datePicker: datePicker)
    }
    override func setLayout() {
        inputGuideLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        usageGuideLabel.snp.makeConstraints {
            $0.top.equalTo(inputGuideLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        selectionGuideLabel.snp.makeConstraints {
            $0.top.equalTo(inputGuideLabel.snp.bottom).offset(63)
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalTo(32)
        }
        datePickerField.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.top.equalTo(inputGuideLabel.snp.bottom).offset(62)
            $0.leading.equalTo(selectionGuideLabel.snp.trailing).offset(65)
            $0.trailing.equalToSuperview().inset(30)
        }
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            if view.frame.width < 400 {
                $0.width.equalTo(164)
            } else {
                $0.width.equalTo(184)
            }
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(40)
        }
        inputButton.snp.makeConstraints {
            $0.leading.equalTo(cancelButton.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
