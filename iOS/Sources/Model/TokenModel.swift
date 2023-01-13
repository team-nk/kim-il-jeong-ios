import Foundation
// swiftlint:disable identifier_name
struct TokenModel: Codable {
    let access_token: String
    let refresh_token: String
    let expired_at: String
}
