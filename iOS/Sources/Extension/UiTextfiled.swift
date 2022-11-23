import UIKit
import SnapKit
import Then
extension UITextField {
    typealias KimIlJeongColor = KimIlJeongAsset.Color
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    func addPaddingToTextField(leftSize: CGFloat, rightSize: CGFloat) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftSize, height: self.frame.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightSize, height: self.frame.height))
        self.leftView = leftPaddingView
        self.rightView = rightPaddingView
        self.leftViewMode = ViewMode.always
        self.rightViewMode = ViewMode.always
    }
    func setTextField(forTextField: UITextField, placeholderText: String) {
        forTextField.attributedPlaceholder = NSAttributedString(string: "\(placeholderText)", attributes: [
            .foregroundColor: KimIlJeongColor.textfieldDeactivationColor.color,
            .font: UIFont.systemFont(ofSize: 16, weight: .light)
        ])
        forTextField.layer.borderWidth = 1
        forTextField.layer.borderColor = KimIlJeongColor.mainColor.color.cgColor
        forTextField.layer.cornerRadius = 10
        forTextField.textColor = KimIlJeongColor.strongExplanation.color
        forTextField.font = .systemFont(ofSize: 18.48, weight: .regular)
    }
}
