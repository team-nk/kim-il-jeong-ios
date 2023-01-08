import Foundation
// swiftlint:disable identifier_name
// MARK: - MySchedulesToken
struct MySchedulesToken: Codable {
    let schedule_list: [MyScheduleList]
}

struct MyScheduleList: Codable {
    let schedule_id: Int
    let content: String
    let color: String
    let start_time: String
    let end_time: String
    let is_always: Bool
}
