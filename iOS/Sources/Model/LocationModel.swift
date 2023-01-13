import Foundation

// MARK: - LocationModel
struct LocationModel: Codable {
    let scheduleList: [LocationList]
    enum CodingKeys: String, CodingKey {
        case scheduleList = "schedule_list"
    }
}

// MARK: - LocationList
struct LocationList: Codable {
    let scheduleId: Int
    let address: String
    let latitude: Double
    let longitude: Double
    enum CodingKeys: String, CodingKey {
        case scheduleId = "schedule_id"
        case latitude, longitude, address
    }
}
