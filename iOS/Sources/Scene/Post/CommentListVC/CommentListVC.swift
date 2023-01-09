import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class CommentListVC: BaseVC {
    private let getComments = BehaviorRelay<Void>(value: ())
    let postID = BehaviorRelay<Int>(value: 0)
    private let viewModel = CommentListVM()
    private let newCommentViewModel = NewCommentVM()
    var keyboardUp: Bool = false
    var commentCount = Int()
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    let commentTableView = ContentWrappingTableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    let commentTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "메세지를 입력하세요...", attributes: [
            .foregroundColor: KimIlJeongColor.textfieldDeactivationColor.color,
            .font: UIFont.systemFont(ofSize: 16, weight: .light)
        ])
        $0.textColor = KimIlJeongColor.textColor.color
        $0.textAlignment = .left
        $0.backgroundColor = KimIlJeongColor.surface2.color
        $0.layer.cornerRadius = 25
        $0.addPaddingToTextField(leftSize: 20, rightSize: 60)
    }
    let sendButton = UIButton().then {
        $0.setImage(UIImage(named: "PaperPlane"), for: .normal)
        $0.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
    }
    private func updateConstraints() {
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            if Double(commentCount * 90) > self.view.frame.height {
                $0.height.equalTo((commentCount) * 40)
            } else {
                $0.height.equalTo(self.view.frame.height)
            }
        }
    }
    private func bindViewModels() {
        let input = CommentListVM.Input(getComments: getComments.asDriver(), postId: postID.asDriver())
        let output = viewModel.transform(input)
        output.comments.bind(to: commentTableView.rx.items(
            cellIdentifier: "CommentCell",
            cellType: CommentCell.self)) { _, items, cell in
                cell.commentLabel.text = items.content
                cell.userLabel.text = items.accountId
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [ .withFullDate, .withTime, .withColonSeparatorInTime ]
                let createdTime = formatter.date(from: items.createTime)
                let createdWhen: String = "\(createdTime!)"
                let endIndex = createdWhen.index(createdWhen.startIndex, offsetBy: 15)
                let range = ...endIndex
                cell.commentDateLabel.text = "\(createdWhen[range])"
                self.commentCount += 1
                self.updateConstraints()
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
    }
    private func sendNewComment() {
        let input = NewCommentVM.Input(
            commentContent: commentTextField.rx.text.orEmpty.asDriver(),
            postID: postID.asDriver(),
            buttonDidTap: getComments.asSignal(onErrorJustReturn: ()))
        let output = newCommentViewModel.transform(input)
        output.postResult
            .subscribe(onNext: {
               print($0)
            }).disposed(by: disposeBag)
    }
    override func addView() {
        view.addSubview(scrollView)
        commentTextField.addSubview(sendButton)
        [
            scrollView,
            commentTextField
        ] .forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        [
            commentTableView
        ]
            .forEach {
                contentView.addSubview($0)
            }
    }
    override func configureVC() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        view.backgroundColor = KimIlJeongColor.backGroundColor.color
        scrollView.contentInsetAdjustmentBehavior = .never
        commentTextField.delegate = self
        setKeyboardObserver()
        bindViewModels()
        sendButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                self.sendNewComment()
                self.commentTextField.text?.removeAll()
            }).disposed(by: disposeBag)
    }
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            if Double(commentCount * 90) > self.view.frame.height {
                $0.height.equalTo((commentCount) * 90)
            } else {
                $0.height.equalTo(self.view.frame.height)
            }
        }
        commentTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(95)
            $0.leading.trailing.equalToSuperview().inset(19)
            $0.bottom.equalTo(commentTextField.snp.top).offset(-10)
        }
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(18)
            if keyboardUp == false {
                $0.bottom.equalToSuperview().inset(44)
            }
        }
        sendButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.54)
        }
    }
}
