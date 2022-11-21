import Foundation

enum NetworkingResult: Int {
    case getOk = 200
    case deleteOk = 204
    case createOk = 201
    case wrongRq = 400
    case tokenError = 401
    case notFound = 404
    case conflict = 409
    case fault = 0
}
