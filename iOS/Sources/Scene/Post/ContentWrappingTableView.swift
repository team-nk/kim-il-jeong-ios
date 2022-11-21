import UIKit

class ContentWrappingTableView: UITableView {
  override var intrinsicContentSize: CGSize {
    return self.contentSize
  }
  override var contentSize: CGSize {
    didSet {
        self.invalidateIntrinsicContentSize()
    }
  }
}
