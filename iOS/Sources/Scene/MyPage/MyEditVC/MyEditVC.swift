import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import PhotosUI
import Alamofire
import RxMoya

class MyEditVC: BaseVC {
    var newImage = BehaviorRelay<UIImage?>(value: nil)
    private let uploadImgVM = NewImageVM()
    private let editProfileVM = EditProfileVM()
    private let getURL = BehaviorRelay<Void>(value: ())
    private let imgURL = BehaviorRelay<String?>(value: "")
    let myProfileImage = UIImageView().then {
        $0.image = KimIlJeongImage.noneProfile.image
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
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
        $0.autocapitalizationType = .none
    }
    let idTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = KimIlJeongColor.mainColor.color
        $0.text = "id"
    }
    let idTextField = UITextField().then {
        $0.setTextField(forTextField: $0, placeholderText: "id")
        $0.addPaddingToTextField(leftSize: 14, rightSize: 14)
        $0.autocapitalizationType = .none
    }
    private let errorMessage = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = KimIlJeongColor.errorColor.color
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
    private func openPhotoLibrary() {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images])
            let image = PHPickerViewController(configuration: configuration)
            image.delegate = self
            self.present(image, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }
    }
    private func postNewImage() {
        let input = NewImageVM.Input(postNewImg: getURL.asDriver(), newProfileImg: newImage.asDriver())
        let output = uploadImgVM.transform(input)
        output.imageURL
            .subscribe(onNext: { url in
                self.imgURL.accept(url)
            }).disposed(by: disposeBag)
        output.getResult
            .subscribe(onNext: {
                if $0 == true {
                    self.patchMyProfile()
                } else {
                    print("thatimagehasn'tbeensent")
                }
            }).disposed(by: disposeBag)
        self.patchMyProfile()
    }
    private func patchMyProfile() {
        let input = EditProfileVM.Input(
            buttonDidTap: getURL.asSignal(onErrorJustReturn: ()),
            email: emailTextField.rx.text.orEmpty.asDriver(),
            accountID: idTextField.rx.text.orEmpty.asDriver(),
            imageURL: imgURL.asDriver())
        let output = editProfileVM.transform(input)
        output.errorMessage
            .subscribe(onNext: {
                self.errorMessage.text = $0
            }).disposed(by: disposeBag)
        output.requestResult
            .subscribe(onNext: {
                if $0 == true {
                    self.navigationController?.popViewController(animated: true)
                    Token.removeToken()
                } else {
                    print("hasn'tbeenedited")
                }
            }).disposed(by: disposeBag)
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
            errorMessage,
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
        imageUpdateButton.rx.tap
            .subscribe(onNext: {
                self.openPhotoLibrary()
            }).disposed(by: disposeBag)
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
                self.postNewImage()
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
        errorMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(passwordEditButton.snp.top).offset(-10)
            $0.height.equalTo(24)
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
