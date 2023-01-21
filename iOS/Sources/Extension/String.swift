import UIKit

extension String {
    func dateFormate() -> String {
        let nowDate = self
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let str = dateFormatter.date(from: nowDate)
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time = myDateFormatter.string(from: str ?? Date())
        return time
    }
    func dateFormateT() -> String {
        let nowDate = self
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let str = dateFormatter.date(from: nowDate)
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let time = myDateFormatter.string(from: str ?? Date())
        return time
    }
    func dateFormatter() -> Date {
        let nowDate = self
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let str = dateFormatter.date(from: nowDate)
        return str!
    }

    func colorDistinction() -> UIColor {
        switch self {
        case "RED":
            return KimIlJeongAsset.Color.redTag.color
        case "BLUE":
            return KimIlJeongAsset.Color.blueTag.color
        case "YELLOW":
            return KimIlJeongAsset.Color.yellowTag.color
        case "GREEN":
            return KimIlJeongAsset.Color.greenTag.color
        default:
            return KimIlJeongAsset.Color.purpleTag.color
        }
    }
    func validpassword() -> Bool {
        let passwordreg =  ("(?=.*[0-9])(?=.*[a-zA-Z]).{8,16}$")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: self)
    }
}
