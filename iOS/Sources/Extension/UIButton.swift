import UIKit
extension UIButton {
    func setUnderline(start: Int) {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: start, length: title.count-start)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
    func setCheckImage() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let checkImage = UIImage(systemName: "checkmark", withConfiguration: imageConfig.self)
        self.setImage(checkImage, for: .normal)
    }
}
