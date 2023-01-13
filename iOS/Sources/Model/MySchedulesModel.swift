import Foundation
// swiftlint:disable identifier_name
// MARK: - MySchedulesModel
struct MySchedulesModel: Codable {
    let schedule_list: [MyScheduleList]
}

// MARK: - MyScheduleList
struct MyScheduleList: Codable {
    let schedule_id: Int
    let content: String
    let color: String
    let start_time: String
    let end_time: String
    let is_always: Bool
}
