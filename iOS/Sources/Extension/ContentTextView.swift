import UIKit
extension PostVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = contentTextView.sizeThatFits(size)
        contentTextView.constraints.forEach { (constraint) in
            if estimatedSize.height <= 300 {
            } else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}
