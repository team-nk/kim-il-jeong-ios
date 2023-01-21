import UIKit

extension Date {
    func dateFormate() -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy-MM-dd HH:mm"
        formmater.locale = Locale(identifier: "ko_KR")
        return formmater.string(from: self)
    }
}
