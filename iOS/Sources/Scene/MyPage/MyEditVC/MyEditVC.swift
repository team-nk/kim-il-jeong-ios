import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class MyEditVC: BaseVC {
    private let myProfileImage = UIImageView().then {
        $0.image = KimIlJeongImage.noneProfile.image
    }
    private let imageUpdateButton = UIButton().then {
        $0.setTitle("이미지 변경하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    }
    let emailTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = KimIlJeongColor.mainColor.color
        $0.text = "Email"
    }
    let emailTextField = UITextField().then {
        $0.setTextField(forTextField: $0, placeholderText: "Email")
        $0.addPaddingToTextField(leftSize: 14, rightSize: 14)
    }
    let idTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = KimIlJeongColor.mainColor.color
        $0.text = "id"
    }
    let idTextField = UITextField().then {
        $0.setTextField(forTextField: $0, placeholderText: "id")
        $0.addPaddingToTextField(leftSize: 14, rightSize: 14)
    }
    private let passwordEditButton = UIButton().then {
        $0.setTitle("비밀번호 변경하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setUnderline(start: 0)
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
    override func addView() {
        [
            myProfileImage,
            imageUpdateButton,
            emailTitleLabel,
            emailTextField,
            idTitleLabel,
            idTextField,
            passwordEditButton,
            cancelButton,
            completeButton
        ] .forEach {
            view.addSubview($0)
        }
    }
    override func configureVC() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "정보 변경하기"
        setNavigation()
        passwordEditButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(PasswordEditVC(), animated: true)
                self.navigationItem.backButtonTitle = ""
            }).disposed(by: disposeBag)
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        completeButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    // swiftlint:disable function_body_length
    override func setLayout() {
        myProfileImage.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(131)
        }
        imageUpdateButton.snp.makeConstraints {
            $0.top.equalTo(myProfileImage.snp.bottom).offset(15)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageUpdateButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(34)
            $0.height.equalTo(20)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        idTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(34)
            $0.height.equalTo(20)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(idTitleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        passwordEditButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().inset(100)
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
    }
}
