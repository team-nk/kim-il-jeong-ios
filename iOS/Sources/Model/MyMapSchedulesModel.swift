import Foundation
// swiftlint:disable identifier_name
// MARK: - MyMapSchedulesToken
struct MyMapSchedulesModel: Codable {
    let schedule_list: [MapScheduleList]
}

// MARK: - ScheduleList
struct MapScheduleList: Codable {
    let schedule_id: Int
    let content: String
    let address: String
    let color: String
    let start_time: String
    let end_time: String
}
