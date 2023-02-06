import Foundation

public func transformISO8601(stringDate: String) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [ .withFullDate, .withTime, .withColonSeparatorInTime ]
    let getDate = formatter.date(from: stringDate)
    let resultDate: String = "\(getDate!)"
    let endIndex = resultDate.index(resultDate.startIndex, offsetBy: 15)
    let range = ...endIndex
    return "\(resultDate[range])"
}

public func currentDateFormatter() -> String {
    let nowDate = Date()
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M월 d일 EEEE"
    let date = formatter.string(from: nowDate)
    return date
}
