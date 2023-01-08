import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class CommentListVC: BaseVC {
    private let getComments = BehaviorRelay<Void>(value: ())
    let postID = BehaviorRelay<Int>(value: 0)
    private let viewModel = CommentListVM()
    var keyboardUp: Bool = false
    var commentArray: [CommentDummies] = []
    let commentList = CommentDummyItems()
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
    @objc func didTapSendButton() {
        commentTextField.text?.removeAll()
    }
    private func updateConstraints() {
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            if Double(commentArray.count * 90) > self.view.frame.height {
                $0.height.equalTo(100 + (commentArray.count) * 90)
                print("1", view.frame.height)
            } else {
                $0.height.equalTo(self.view.frame.height)
                print(self.view.frame.height)
            }
        }
    }
    func addDummies() {
        commentArray = [
            commentList.cmt1, commentList.cmt2, commentList.cmt3,
            commentList.cmt4, commentList.cmt5, commentList.cmt6,
            commentList.cmt7, commentList.cmt8, commentList.cmt9,
            commentList.cmt10, commentList.cmt11,
            commentList.cmt12, commentList.cmt1, commentList.cmt2
        ]
        updateConstraints()
    }
    func setUpViews() {
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTextField.delegate = self
    }
    private func bindViewModels() {
        let input = CommentListVM.Input(getComments: getComments.asDriver(), postId: postID.asDriver())
        let output = viewModel.transform(input)
        output.comments.bind(to: commentTableView.rx.items(
            cellIdentifier: "CommentCell",
            cellType: CommentCell.self)) { row, items, cell in
                cell.commentLabel.text = items.content
                cell.userLabel.text = items.accountId
                cell.commentDateLabel.text = items.createTime
            }.disposed(by: disposeBag)
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
        setKeyboardObserver()
        bindViewModels()
//        addDummies()
//        setUpViews()
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            if Double(commentArray.count * 90) > self.view.frame.height {
                $0.height.equalTo(100 + (commentArray.count) * 90)
                print("1", view.frame.height)
            } else {
                $0.height.equalTo(self.view.frame.height)
                print(self.view.frame.height)
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
