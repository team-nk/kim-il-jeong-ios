import Foundation

struct UserInfoModel: Codable {
    let profile: String?
    let accountId: String
    let email: String
    enum CodingKeys: String, CodingKey {
        case profile
        case accountId = "account_id"
        case email
    }
}
