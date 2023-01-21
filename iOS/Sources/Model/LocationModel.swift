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
    let buildingName: String
    let latitude: String
    let longitude: String
    let color: String
    enum CodingKeys: String, CodingKey {
        case scheduleId = "schedule_id"
        case buildingName = "building_name"
        case latitude, longitude, color
    }
}
