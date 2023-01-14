import Foundation

struct BirthdayListModel: Codable {
    let userList: [Users]
    enum CodingKeys: String, CodingKey {
        case userList = "user_list"
    }
}
struct Users: Codable {
    let accountId: String
    let age: Int
    let birthday: String
    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case age
        case birthday
    }
}

struct PostListModel: Codable {
    let postList: [Posts]
    enum CodingKeys: String, CodingKey {
        case postList = "post_list"
    }
}
struct Posts: Codable {
    let id: Int
    let title: String
    let scheduleContent: String
    let address: String
    let color: String
    let mine: Bool
    let accountId: String
    let createTime: String
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case scheduleContent = "schedule_content"
        case address
        case color
        case mine = "is_mine"
        case accountId = "account_id"
        case createTime = "create_time"
    }
}
struct PostDetailModel: Codable {
    let title: String
    let content: String
    let scheduleContent: String
    let address: String
    let color: String
    let commentCount: Int
    let mine: Bool
    let accountId: String
    let createTime: String
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case scheduleContent = "schedule_content"
        case address
        case color
        case commentCount = "comment_count"
        case mine = "is_mine"
        case accountId = "account_id"
        case createTime = "create_time"
    }
}
