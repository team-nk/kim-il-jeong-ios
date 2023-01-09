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
    // Post
    case getBirthdayUsers
    case getAllSchedules
    case postNewPost(_ title: String, _ content: String, _ scheduleId: Int)
    case getAllComments(postId: Int)
    case postNewComment(content: String, postId: Int)
    case getMySchedule
    case refreshToken
    case getMapSchedule
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
        // Post
        case .getBirthdayUsers:
            return "/post/birthday"
        case .getAllSchedules:
            return "/post"
        case .postNewPost:
            return "/post"
        case .getAllComments(let id):
            return "/comment/\(id)"
        case .postNewComment(_, let id):
            return "/comment/\(id)"
        case .getMySchedule:
            return "/schedule/list"
        case .refreshToken:
            return "/auth"
        case .getMapSchedule:
            return "/schedule/map"
        }
    }

    var method: Moya.Method {
        switch self {
        case .imageUproad, .postCreate, .login, .signup, .postNewPost, .postNewComment:
            return .post
        case .sendEmail, .codeCheck, .postSerach, .idCheck, .getBirthdayUsers, .getAllSchedules, .getAllComments, .getMySchedule, .getMapSchedule:
            return .get
        case .refreshToken:
            return .put
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
        default:
            return .requestPlain
        case .getBirthdayUsers:
            return .requestPlain
        case .getAllSchedules:
            return .requestPlain
        case .postNewPost(let title, let content, let scheduleId):
            return .requestParameters(
                parameters:
                    [
                        "title": title,
                        "content": content,
                        "scheduleId": scheduleId
                    ],
                encoding: JSONEncoding.prettyPrinted)
        case .getAllComments(let id):
            return .requestParameters(parameters: [
                "post-id": id
            ], encoding: URLEncoding.queryString)
        case .postNewComment(let content, _):
            return .requestParameters(
                parameters:
                    [
                        "content": content
                    ],
                encoding: JSONEncoding.prettyPrinted)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .imageUproad, .postSerach, .postCreate, .getBirthdayUsers, .getAllSchedules,
                .postNewPost, .getAllComments, .postNewComment, .getMySchedule, .getMapSchedule:
            return Header.accessToken.header()
        case .login, .signup, .sendEmail, .codeCheck, .idCheck:
            return Header.tokenIsEmpty.header()
        case .refreshToken:
            return Header.refreshToken.header()
        }
    }
}
