import Foundation
import Moya

enum API {
    case imageUproad(image: String)
    case postCreate(title: String, content: String, scheduleId: Int)
    case postSerach
    case login(email: String, password: String)
    case signup(email: String, code: String, accountId: String, password: String, rePassword: String)
    case sendEmail(email: String)
    case codeCheck(email: String, code: String)
    case idCheck(accountId: String)
    case getMySchedule
    case refreshToken
    case getMapSchedule
    case deleteSchedule(scheduleId: Int)
    case postSchedule(content: String, address: String, color: String,
                      startTime: String, endTime: String, isAlways: Bool)
    case putSchedule(scheduleId: Int, content: String, address: String, color: String,
                      startTime: String, endTime: String, isAlways: Bool)
    case getLocation
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
        case .login:
            return "/user/login"
        case .signup:
            return "/user"
        case .sendEmail:
            return "/mail"
        case .codeCheck:
            return "/user/code"
        case .idCheck:
            return "/user/check"
        case .getMySchedule:
            return "/schedule/list"
        case .refreshToken:
            return "/auth"
        case .getMapSchedule:
            return "/schedule/map"
        case .deleteSchedule(let scheduleId):
            return "/schedule/\(scheduleId)"
        case .postSchedule:
            return "/schedule"
        case .putSchedule(let scheduleId, _, _, _, _, _, _):
            return "/schedule/\(scheduleId)"
        case .getLocation:
            return "/schedule/location"
        }
    }
    var method: Moya.Method {
        switch self {
        case .imageUproad, .postCreate, .login, .signup, .postSchedule:
            return .post
        case .sendEmail, .codeCheck, .postSerach, .idCheck,
                .getMySchedule, .getMapSchedule, .getLocation:
            return .get
        case .refreshToken, .putSchedule:
            return .put
        case .deleteSchedule:
            return .delete
        }
    }
    var task: Task {
        switch self {
        case .imageUproad(let image):
            return .requestParameters(parameters:
                                        [
                                            "image": image
                                        ],
                                      encoding: JSONEncoding.prettyPrinted)
        case .postCreate(let title, let content, let scheduleId):
            return .requestParameters(parameters:
                                        [
                                            "title": title,
                                            "content": content,
                                            "scheduleId": scheduleId
                                        ], encoding: JSONEncoding.prettyPrinted)
        case .login(let email, let password):
            return .requestParameters(parameters:
                                        [
                                            "email": email,
                                            "password": password
                                        ], encoding: JSONEncoding.prettyPrinted)
        case .signup(let email, let code, let accountId, let password, let rePassword):
            return .requestParameters(parameters:
                                        [
                                            "email": email,
                                            "code": code,
                                            "account_id": accountId,
                                            "password": password,
                                            "re_password": rePassword
                                        ], encoding: JSONEncoding.prettyPrinted)
        case .sendEmail(let email):
            return .requestParameters(parameters:
                                        [
                                            "email": email
                                        ]
                                      , encoding: URLEncoding.queryString)
        case .codeCheck(let email, let code):
            return .requestParameters(parameters:
                                        [
                                            "email": email,
                                            "code": code
                                        ], encoding: URLEncoding.queryString)
        case .idCheck(let accountId):
            return .requestParameters(parameters:
                                        [
                                            "account-id": accountId
                                        ], encoding: URLEncoding.queryString)
        case .postSchedule(let content, let address, let color, let startTime, let endTime, let isAlways):
            return .requestParameters(parameters:
                                        [
                                            "content": content,
                                            "address": address,
                                            "color": color,
                                            "start_time": startTime,
                                            "end_time": endTime,
                                            "is_always": isAlways
                                        ], encoding: JSONEncoding.prettyPrinted)
        case .putSchedule( _, let content, let address, let color, let startTime, let endTime, let isAlways):
            return .requestParameters(parameters:
                                        [
                                            "content": content,
                                            "address": address,
                                            "color": color,
                                            "start_time": startTime,
                                            "end_time": endTime,
                                            "is_always": isAlways
                                        ], encoding: JSONEncoding.prettyPrinted)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .imageUproad, .postSerach, .postCreate,
                .getMySchedule, .getMapSchedule, .deleteSchedule,
                .postSchedule, .getLocation, .putSchedule:
            return Header.accessToken.header()
        case .login, .signup, .sendEmail, .codeCheck, .idCheck:
            return Header.tokenIsEmpty.header()
        case .refreshToken:
            return Header.refreshToken.header()
        }
    }
}
