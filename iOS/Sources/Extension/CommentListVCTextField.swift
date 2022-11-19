import UIKit
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
        let heiget = keyboardFrame!.size.height
        keyboardUp = true
        if keyboardUp == true {
            self.commentTextField.snp.remakeConstraints {
                $0.bottom.equalToSuperview().inset(10 + heiget)
            }
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(noti: Notification) {
        let notinfo = noti.userInfo!
        let keyboardFrame = notinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        keyboardUp = false
        if keyboardUp == false {
            self.commentTextField.snp.remakeConstraints {
                $0.bottom.equalToSuperview().inset(44)
            }
            self.view.layoutIfNeeded()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
}

