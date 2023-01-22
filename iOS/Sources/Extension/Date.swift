import UIKit

extension Date {
    func dateFormate() -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy-MM-dd HH:mm"
        formmater.locale = Locale(identifier: "ko_KR")
        return formmater.string(from: self)
    }
    func birthDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
