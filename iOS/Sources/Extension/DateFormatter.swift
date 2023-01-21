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
