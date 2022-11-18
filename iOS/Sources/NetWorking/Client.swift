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
        }
    }

    var method: Moya.Method {
        switch self {
        case .imageUproad, .postCreate, .login, .signup:
            return .post
        case .sendEmail, .codeCheck, .postSerach, .idCheck:
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
                                            "account_id": accountId
                                        ], encoding: URLEncoding.queryString)
        case .postSerach:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .imageUproad, .postSerach, .postCreate:
            return Header.accessToken.header()
        case .login, .signup, .sendEmail, .codeCheck, .idCheck:
            return Header.tokenIsEmpty.header()
        }
    }
}
