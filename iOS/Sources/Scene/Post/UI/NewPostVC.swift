import UIKit
import RxSwift
import RxFlow
import SnapKit
import Then

class NewPostVC: BaseVC<NewPostVCReactor> {
    private let contentTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.text = "내용을 입력하세요(첫 줄은 제목입니다.)"
        $0.textColor = UIColor(named: "PlaceholderColor")
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
            $0.width.equalTo(184)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(40)
        }
        createButton.snp.makeConstraints {
            $0.top.equalTo(scheduleButton.snp.bottom).offset(30)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
//            $0.width.equalTo(184)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

extension NewPostVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.text = "내용을 입력하세요(첫 줄은 제목입니다.)"
            contentTextView.textColor = UIColor(named: "PlaceholderColor")
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.textColor == UIColor(named: "PlaceholderColor") {
            contentTextView.text = nil
            contentTextView.textColor = KimIlJeongColor.textColor.color
        }
    }
}
