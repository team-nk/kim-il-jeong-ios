import Foundation
import Moya

enum API {
    case imageUproad(image: String)
    case postCreate(title: String, content: String, scheduleId: Int)
    case postSerach
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "http://52.79.125.202:8888")!
    }

    var path: String {
        switch self {
        case .imageUproad:
            return "/image"
        case .postSerach:
            return "/post"
        case .postCreate:
            return "/post"
        }

    }

    var method: Moya.Method {
        switch self {
        case .imageUproad, .postCreate:
            return .post
        case .postSerach:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .imageUproad(let image):
            return .requestParameters(parameters:
                                        [
                                            "image": image
                                        ],
                                      encoding: JSONEncoding.default)
        case .postCreate(let title, let content, let scheduleId):
            return .requestParameters(parameters:
                                        [
                                            "title": title,
                                            "content": content,
                                            "scheduleId": scheduleId
                                        ], encoding: JSONEncoding.default)
        case .postSerach:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .imageUproad, .postSerach, .postCreate:
            return Header.accessToken.header()
        }
    }
}
