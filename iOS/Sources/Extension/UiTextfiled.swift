import UIKit
import SnapKit
import Then
extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    func addPaddingToCommentTextField() {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: self.frame.height))
        self.leftView = leftPaddingView
        self.rightView = rightPaddingView
        self.leftViewMode = ViewMode.always
        self.rightViewMode = ViewMode.always
    }
}
