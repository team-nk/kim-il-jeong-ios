import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PostVC: BaseVC {
    let postTitleLabel = UILabel().then {
        $0.text = "Starbucks 인수 결정했습니다!"
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = KimIlJeongColor.textColor.color
        $0.textAlignment = .left
    }
    let colorTag = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.image = UIImage(systemName: "circle.fill")
    }
    let scheduleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = KimIlJeongColor.textColor.color
        $0.textAlignment = .left
    }
    let userNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = KimIlJeongColor.textColor.color
        $0.textAlignment = .right
    }
    let locationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = KimIlJeongColor.description.color
        $0.textAlignment = .left
    }
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = KimIlJeongColor.description.color
        $0.textAlignment = .right
    }
    let separatorLine = UIView().then {
        $0.backgroundColor = KimIlJeongColor.description.color
    }
    let contentTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = KimIlJeongColor.textColor.color
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    private let commentButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = KimIlJeongColor.surface2.color
    }
    private let commentCountLabel = UILabel().then {
        $0.text = "댓글 12개"
        $0.textColor = KimIlJeongColor.strongExplanation.color
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 16, weight: .light)
    }
    private let writeCommentLabel = UILabel().then {
        $0.text = "댓글 작성하기"
        $0.textAlignment = .right
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    override func addView() {
        [
            commentCountLabel,
            writeCommentLabel
        ] .forEach {
            commentButton.addSubview($0)
        }
        [
            postTitleLabel,
            colorTag,
            scheduleLabel,
            userNameLabel,
            locationLabel,
            dateLabel,
            separatorLine,
            contentTextView,
            commentButton
        ]
            .forEach {
                view.addSubview($0)
            }
    }
    override func configureVC() {
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = KimIlJeongColor.backGroundColor.color
        commentButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(CommentListVC(), animated: true)
            }).disposed(by: disposeBag)
    }
    override func setLayout() {
        postTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(101)
            $0.height.equalTo(30)
            $0.leading.trailing.equalToSuperview().inset(19)
        }
        colorTag.snp.makeConstraints {
            $0.width.height.equalTo(10)
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(19)
        }
        scheduleLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(10)
            $0.height.equalTo(20)
            $0.leading.equalTo(colorTag.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(94)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(10)
            $0.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(19)
        }
        locationLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(scheduleLabel.snp.bottom).offset(0)
            $0.leading.equalToSuperview().inset(19)
            $0.trailing.equalToSuperview().inset(105)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(0)
            $0.height.equalTo(20)
            $0.leading.equalTo(locationLabel.snp.trailing).offset(0)
            $0.trailing.equalToSuperview().inset(19)
        }
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(19)
            $0.height.equalTo(1)
            $0.top.equalTo(locationLabel.snp.bottom).offset(9)
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        commentButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(44)
        }
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        writeCommentLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
}
