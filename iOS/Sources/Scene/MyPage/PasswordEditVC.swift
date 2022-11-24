import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PasswordEditVC: BaseVC {
    private let passwordViewModel = PasswordEditViewModel()
    private let oldPWTextField = UITextField().then {
        $0.addPaddingToTextField(leftSize: 14, rightSize: 14)
        $0.setTextField(forTextField: $0, placeholderText: "기존 Password를 입력하세요")
    }
    private let newPWTextField = UITextField().then {
        $0.addPaddingToTextField(leftSize: 14, rightSize: 14)
        $0.setTextField(forTextField: $0, placeholderText: "새로운 Password를 입력하세요")
    }
    private let newPWCheckTextField = UITextField().then {
        $0.addPaddingToTextField(leftSize: 14, rightSize: 14)
        $0.setTextField(forTextField: $0, placeholderText: "새로운 Password를 한 번 더 입력하세요")
    }
    let newPWGuideLabel = UILabel().then {
        $0.text = "비밀번호는 숫자 + 문자를 사용하여 8글자 이상 15글자 이하로 만들어 주세요."
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    private let cancelButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = KimIlJeongColor.backGroundColor.color
        $0.setTitle("취소하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18.48, weight: .bold)
    }
    private let completeButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = KimIlJeongColor.mainColor.color
        $0.setTitle("변경하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.surfaceColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18.48, weight: .bold)
    }
    let errorMessage = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = KimIlJeongColor.errorColor.color
    }
    override func addView() {
        [
            oldPWTextField,
            newPWTextField,
            newPWCheckTextField,
            newPWGuideLabel,
            cancelButton,
            completeButton,
            errorMessage
        ] .forEach {
            view.addSubview($0)
        }
    }
    override func bind() {
        let input = PasswordEditViewModel.Input(oldPassword: oldPWTextField.rx.text.orEmpty.asDriver(),
                                                newPassword: newPWTextField.rx.text.orEmpty.asDriver(),
                                                newPasswordCheck: newPWCheckTextField.rx.text.orEmpty.asDriver(),
                                                buttonDidTap: completeButton.rx.tap.asSignal())
        let output = passwordViewModel.transform(input)
        output.error.asObservable()
            .subscribe(onNext: {
                self.errorMessage.text = $0
            }).disposed(by: disposeBag)
    }
    override func configureVC() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "비밀번호 변경"
        setNavigation()
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    override func setLayout() {
        oldPWTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(131)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        newPWTextField.snp.makeConstraints {
            $0.top.equalTo(oldPWTextField.snp.bottom).offset(15)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        newPWCheckTextField.snp.makeConstraints {
            $0.top.equalTo(newPWTextField.snp.bottom).offset(15)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        newPWGuideLabel.snp.makeConstraints {
            $0.top.equalTo(newPWCheckTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
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
        completeButton.snp.makeConstraints {
            $0.leading.equalTo(cancelButton.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(40)
        }
        errorMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(96)
            $0.height.equalTo(24)
        }
    }
}
