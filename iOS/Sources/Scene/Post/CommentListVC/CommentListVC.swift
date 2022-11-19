import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class CommentListVC: BaseVC {
    var commentArray: [Comments] = []
    let commentList = CommentDummies()
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
    private let commentTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "메세지를 입력하세요...", attributes: [
            .foregroundColor: KimIlJeongColor.textfieldDeactivationColor.color,
            .font: UIFont.systemFont(ofSize: 16, weight: .light)
        ])
        $0.textColor = KimIlJeongColor.textColor.color
        $0.textAlignment = .left
        $0.backgroundColor = KimIlJeongColor.surface2.color
        $0.layer.cornerRadius = 25
    }
    private let sendButton = UIButton().then {
        $0.setImage(UIImage(named: "PaperPlane"), for: .normal)
        $0.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        $0.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
    @objc func didTapSendButton() {
        commentTextField.text?.removeAll()
    }
//    var keyHeight: CGFloat?
    func addDummies() {
        commentArray = [
            commentList.cmt1, commentList.cmt2, commentList.cmt3,
            commentList.cmt4, commentList.cmt5, commentList.cmt6,
            commentList.cmt7, commentList.cmt8, commentList.cmt9,
            commentList.cmt10, commentList.cmt11,
            commentList.cmt12
        ]
    }
    func setUpTableView() {
        commentTableView.delegate = self
        commentTableView.dataSource = self
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
        navigationController!.navigationBar.backItem?.title = nil
        view.backgroundColor = KimIlJeongColor.backGroundColor.color
        scrollView.contentInsetAdjustmentBehavior = .never
        commentTextField.addPaddingToCommentTextField()
        setKeyboardObserver()
        commentTextField.delegate = self
        addDummies()
        setUpTableView()
    }
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            if commentArray.count * 90 > 800 {
                $0.height.equalTo(100 + (commentArray.count) * 90)
            } else {
                $0.height.equalTo(900)
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
            $0.bottom.equalToSuperview().inset(44)
        }
        sendButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.54)
        }
    }
}

extension CommentListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
            cell.commentLabel.text = "\(commentArray[indexPath.row].content)"
            cell.userLabel.text = "\(commentArray[indexPath.row].accountId)"
            cell.commentDateLabel.text = "\(commentArray[indexPath.row].createTime)"
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

extension CommentListVC: UITextFieldDelegate {
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    @objc func keyboardWillShow(noti: Notification) {
        let notinfo = noti.userInfo!
        let keyboardFrame = notinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let heiget = -(keyboardFrame!.size.height - self.view.safeAreaInsets.bottom + 50)
        let animateDuration = notinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: animateDuration!) {
//            self.commentTextField.snp.updateConstraints {
//                $0.bottom.equalTo(heiget)
//            }
            self.commentTextField.frame.origin.y += heiget
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(noti: Notification) {
        let notinfo = noti.userInfo!
        let animateDuration = notinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: animateDuration!) {
            self.commentTextField.snp.updateConstraints {
                $0.bottom.equalTo(-50)
            }
            self.view.layoutIfNeeded()
        }
    }
    //    func setKeyboardObserver() {
    //        NotificationCenter.default.addObserver(
    //          self,
    //          selector: #selector(keyboardDidShow),
    //          name: UIResponder.keyboardDidShowNotification,
    //          object: nil
    //        )
    //        NotificationCenter.default.addObserver(
    //          self,
    //          selector: #selector(keyboardDidHide),
    //          name: UIResponder.keyboardDidHideNotification,
    //          object: nil
    //        )
    //    }
    //    @objc private func keyboardDidShow(_ notification: Notification) {
    //      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
    //        let keybaordRectangle = keyboardFrame.cgRectValue
    //        let keyboardHeight = keybaordRectangle.height
    //        view.frame.origin.y -= keyboardHeight - 10
    //      }
    //    }
    //    @objc private func keyboardDidHide(_ notification: Notification) {
    //      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
    //        let keyboardRectangle = keyboardFrame.cgRectValue
    //        let keyboardHeight = keyboardRectangle.height
    //        view.frame.origin.y += keyboardHeight - 10
    //      }
    //    }
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        if let keyboardFrame: NSValue = Notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] {
    //            let keyboardRectangle = keyboardFrame.cgRectValue
    //            let keyboardHeight = keyboardRectangle.height
    //            view.frame.origin.y += keyboardHeight
    //        }
    //    }
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        commentTextField.becomeFirstResponder()
    //        return true
    //    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
}
