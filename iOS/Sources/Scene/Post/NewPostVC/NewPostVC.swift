import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

public let scheduleIDForNew = PublishRelay<Int>()
public let scheduleContentForNew = BehaviorRelay<String>(value: "")

class NewPostVC: BaseVC {
    private let viewModel = NewPostVM()
    private let contentTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.text = "내용을 입력하세요(첫 줄은 제목입니다.)"
        $0.textColor = KimIlJeongColor.placeholderColor.color
        $0.font = .systemFont(ofSize: 18, weight: .regular)
    }
    private let scheduleButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = KimIlJeongColor.surface2.color
    }
    private let placeholderLabel = UILabel().then {
        $0.text = "일정을 선택해 주세요"
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.font = UIFont(name: "SF Pro", size: 16)
    }
    private let chooseLabel = UILabel().then {
        $0.text = "일정 선택"
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    private let cancelButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = KimIlJeongColor.backGroundColor.color
        $0.setTitle("취소하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18.48, weight: .bold)
    }
    private let createButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = KimIlJeongColor.mainColor.color
        $0.setTitle("생성하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.surfaceColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18.48, weight: .bold)
    }
    private func setButtonTitle() {
        isSheetClosed
            .subscribe(onNext: {
                if $0 == true {
                    self.dismiss(animated: true)
                    scheduleContentForNew
                        .bind(to: self.placeholderLabel.rx.text)
                        .disposed(by: self.disposeBag)
                } else {
                    print($0)
                }
            }).disposed(by: disposeBag)
    }
    override func bind() {
        setButtonTitle()
        let titleString = PublishRelay<String>()
        let contentString = PublishRelay<String>()
        createButton.rx.tap
            .subscribe(onNext: {
                let temp = self.contentTextView.text.split(separator: "\n")
                titleString.accept("\(temp[0])")
                contentString.accept("\(temp[1])")
            }).disposed(by: disposeBag)
        let input = NewPostVM.Input(
            buttonDidTap: self.createButton.rx.tap.asSignal(),
            newTitle: titleString.asDriver(onErrorJustReturn: ""),
            newContent: contentString.asDriver(onErrorJustReturn: ""),
            scheduleID: scheduleIDForNew.asDriver(onErrorJustReturn: 0)
        )
        let output = self.viewModel.transform(input)
        output.postResult
            .subscribe(onNext: {
                if $0 == true {
                    self.navigationController?.popViewController(animated: true)
                    scheduleContentForNew.accept("일정을 선택해 주세요")
                } else {
                    print("false")
                }
            }).disposed(by: self.disposeBag)
    }
    override func addView() {
        [
            placeholderLabel,
            chooseLabel
        ]
            .forEach {
                scheduleButton.addSubview($0)
            }
        [
            contentTextView,
            scheduleButton,
            cancelButton,
            createButton
        ]
            .forEach {
                view.addSubview($0)
            }
    }
    override func configureVC() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "새 글 작성"
        setNavigation()
        contentTextView.delegate = self
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        scheduleButton.rx.tap
            .subscribe(onNext: {
                let next = DetailMapVC()
                next.isNewPost.accept(true)
                next.titleLabel.text = "일정을 선택해 주세요"
                next.plusButton.tintColor = .clear
                self.present(next, animated: true)
                if #available(iOS 16.0, *) {
                    if let presentationController = next.presentationController as? UISheetPresentationController {
                        presentationController.detents = [
                            .custom { _ in
                                return 700
                            }
                        ]
                        presentationController.preferredCornerRadius = 20
                    }
                } else { /*Fallback on earlier versions*/ }
            }).disposed(by: disposeBag)
    }
    override func setLayout() {
        contentTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(111)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(20)
        }
        placeholderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        chooseLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        scheduleButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(contentTextView.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(scheduleButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
            if view.frame.width < 400 {
                $0.width.equalTo(164)
            } else {
                $0.width.equalTo(184)
            }
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(40)
        }
        createButton.snp.makeConstraints {
            $0.top.equalTo(scheduleButton.snp.bottom).offset(30)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

extension NewPostVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.text = "내용을 입력하세요(첫 줄은 제목입니다.)"
            contentTextView.textColor = KimIlJeongColor.placeholderColor.color
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.textColor == KimIlJeongColor.placeholderColor.color {
            contentTextView.text = nil
            contentTextView.textColor = KimIlJeongColor.textColor.color
        }
    }
}
