import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PostVC: BaseVC {
    private let getDetails = BehaviorRelay<Void>(value: ())
    private let viewModel = PostVM()
    private let isMyPost = BehaviorRelay<Bool>(value: false)
    let postID = BehaviorRelay<Int>(value: 0)
    private let postCommentCount = BehaviorRelay<Int>(value: 0)
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
        $0.textAlignment = .left
        $0.isEditable = false
        $0.isSelectable = false
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    private let commentButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = KimIlJeongColor.surface2.color
    }
    let commentCountLabel = UILabel().then {
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
    private let editButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    private let deleteButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    private func setDetails() {
        self.isMyPost.subscribe(onNext: {
            if $0 == false {
                self.commentCountLabel.text = "댓글 \(self.postCommentCount.value)개"
            } else {
                self.commentCountLabel.text = nil
                self.editButton.setImage(UIImage(named: "Pencil_fill"), for: .normal)
                self.deleteButton.setImage(UIImage(named: "Trash"), for: .normal)
            }
        }).disposed(by: disposeBag)
    }
    override func bind() {
        let input = PostVM.Input(getContent: getDetails.asDriver(), postId: postID.asDriver())
        let output = viewModel.transform(input)
        output.postDetail
            .subscribe(onNext: {
                self.isMyPost.accept($0?.mine ?? false)
                self.postCommentCount.accept($0?.commentCount ?? 0)
                self.setDetails()
                self.postTitleLabel.text = $0?.title
                switch $0?.color {
                case "RED":
                    self.colorTag.tintColor = KimIlJeongColor.errorColor.color
                case "BLUE":
                    self.colorTag.tintColor = KimIlJeongColor.mainColor.color
                case "YELLOW":
                    self.colorTag.tintColor = KimIlJeongColor.yellowColor.color
                case "GREEN":
                    self.colorTag.tintColor = KimIlJeongColor.greenColor.color
                case "PURPLE":
                    self.colorTag.tintColor = KimIlJeongColor.purpleColor.color
                default:
                    print("ColorEmpty2")
                }
                self.scheduleLabel.text = $0?.scheduleContent
                self.userNameLabel.text = $0?.accountId
                self.locationLabel.text = $0?.address
                self.dateLabel.text = $0?.createTime
                self.contentTextView.text = $0?.content
            }).disposed(by: disposeBag)
    }
    override func addView() {
        [
            commentCountLabel,
            writeCommentLabel,
            editButton,
            deleteButton
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
        self.navigationController?.navigationItem.backButtonTitle = ""
        view.backgroundColor = KimIlJeongColor.backGroundColor.color
        commentButton.rx.tap
            .subscribe(onNext: {
                let nextVC = CommentListVC()
                nextVC.navigationController?.navigationItem.backButtonTitle = " "
                nextVC.postID.accept(self.postID.value)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }).disposed(by: disposeBag)
    }
    func setPostDetailLayout() {
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
    }
    override func setLayout() {
        setPostDetailLayout()
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(19)
            $0.height.equalTo(1)
            $0.top.equalTo(locationLabel.snp.bottom).offset(9)
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview().inset(15)
        }
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.leading.equalTo(editButton.snp.trailing).offset(15)
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
