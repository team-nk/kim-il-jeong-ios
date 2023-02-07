import Foundation

struct CommentModel: Codable {
    let commentList: [Comments]
    enum CodingKeys: String, CodingKey {
        case commentList = "comment_list"
    }
}
struct Comments: Codable {
    let content: String
    let accountId: String
    let profile: String?
    let createTime: String
    enum CodingKeys: String, CodingKey {
        case content
        case accountId = "account_id"
        case profile
        case createTime = "create_time"
    }
}
