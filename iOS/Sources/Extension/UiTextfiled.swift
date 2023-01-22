import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

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
    func setModifyTextField(textColor: UIColor, backGroundColor: UIColor) {
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        self.layer.cornerRadius = 8
        self.backgroundColor = backGroundColor
        self.textAlignment = .center
    }
    func setToolBar(width: CGFloat, disposeBag: DisposeBag, datePicker: UIDatePicker) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: nil)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
        barButton.rx.tap.subscribe(onNext: { [self] in
            self.resignFirstResponder()
        }).disposed(by: disposeBag)
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        self.inputView = datePicker
    }
    func setBirthDayPicker(width: CGFloat, disposeBag: DisposeBag, datePicker: UIDatePicker) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: nil)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
        barButton.rx.tap.subscribe(onNext: { [self] in
            self.resignFirstResponder()
        }).disposed(by: disposeBag)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        self.inputView = datePicker
    }
}
