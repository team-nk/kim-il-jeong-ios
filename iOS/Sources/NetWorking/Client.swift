import Foundation
import UIKit
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
    case refreshToken
    // Map
    case getMySchedule
    case getMapSchedule
    case deleteSchedule(scheduleId: Int)
    case postSchedule(content: String, address: String, color: String,
                      startTime: String, endTime: String, isAlways: Bool)
    case putSchedule(scheduleId: Int, content: String, address: String, color: String,
                      startTime: String, endTime: String, isAlways: Bool)
    case getLocation
    // Post
    case getBirthdayUsers
    case getAllPosts
    case getDetailPost(postId: Int)
    case postNewPost(_ title: String, _ content: String, _ scheduleId: Int)
    case getAllComments(postId: Int)
    case postNewComment(content: String, postId: Int)
    // User
    case getMyInfo
    case patchMyBirth(birthDate: String)
    case patchMyPW(oldPW: String, newPW: String, newCheck: String)
    case postImage(img: UIImage)
    case patchMyNewProfile(_ email: String, _ accountId: String, _ profileURL: String)
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
        case .refreshToken:
            return "/auth"
        // Map
        case .getMySchedule:
            return "/schedule/list"
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
        // Post
        case .getBirthdayUsers:
            return "/post/birthday"
        case .getAllPosts:
            return "/post"
        case .getDetailPost(let id):
            return "/post/\(id)"
        case .postNewPost:
            return "/post"
        case .getAllComments(let id):
            return "/comment/\(id)"
        case .postNewComment(_, let id):
            return "/comment/\(id)"
        // User
        case .getMyInfo:
            return "/user"
        case .patchMyBirth:
            return "/user/birthday"
        case .patchMyPW:
            return "/user/password"
        case .postImage:
            return "/image"
        case .patchMyNewProfile:
            return "/user"
        }
    }
    var method: Moya.Method {
        switch self {
        case .imageUproad, .postCreate, .login, .signup, .postNewPost, .postNewComment, .postSchedule, .postImage:
            return .post
        case .sendEmail, .codeCheck, .postSerach, .idCheck, .getBirthdayUsers, .getAllPosts,
                .getDetailPost, .getAllComments, .getMySchedule, .getMapSchedule, .getMyInfo, .getLocation:
            return .get
        case .refreshToken, .putSchedule:
            return .put
        case .patchMyBirth, .patchMyPW, .patchMyNewProfile:
            return .patch
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
        case .getBirthdayUsers:
            return .requestPlain
        case .getAllPosts:
            return .requestPlain
        case .getDetailPost:
            return .requestPlain
        case .postNewPost(let title, let content, let scheduleId):
            return .requestParameters(
                parameters:
                    [
                        "title": title,
                        "content": content,
                        "schedule_id": scheduleId
                    ],
                encoding: JSONEncoding.prettyPrinted)
        case .getAllComments:
            return .requestPlain
        case .postNewComment(let content, _):
            return .requestParameters(
                parameters:
                    [
                        "content": content
                    ],
                encoding: JSONEncoding.prettyPrinted)
        // User
        case .patchMyBirth(let date):
            return .requestParameters(
                parameters:
                    [
                        "birthday": date
                    ],
                encoding: JSONEncoding.prettyPrinted)
        case .patchMyPW(let old, let new, let check):
            return .requestParameters(
                parameters:
                    [
                        "now_password": old,
                        "new_password": new,
                        "new2_password": check
                    ],
                encoding: JSONEncoding.prettyPrinted)
        case .postImage(let image):
            var multiPartFormData = [MultipartFormData]()
            let img = image.jpegData(compressionQuality: 0.5)
            let imgData = MultipartFormData(
                provider: .data(img!),
                name: "image",
                fileName: "image.jpg",
                mimeType: "image/jpeg")
            multiPartFormData.append(imgData)
            return .uploadMultipart(multiPartFormData)
        case .patchMyNewProfile(let email, let id, let url):
            return .requestParameters(
                parameters:
                    [
                        "email": email,
                        "account_id": id,
                        "profile": url
                    ],
                encoding: JSONEncoding.prettyPrinted)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .imageUproad, .postSerach, .postCreate, .getBirthdayUsers, .getAllPosts,
                .getDetailPost, .postNewPost, .getAllComments, .postNewComment, .getMySchedule,
                .getMapSchedule, .getMyInfo, .patchMyBirth, .patchMyPW, .patchMyNewProfile,
                .deleteSchedule, .postSchedule, .getLocation, .putSchedule:
            return Header.accessToken.header()
        case .login, .signup, .sendEmail, .codeCheck, .idCheck:
            return Header.tokenIsEmpty.header()
        case .refreshToken:
            return Header.refreshToken.header()
        case .postImage:
            return Header.uploadImage.header()
        }
    }
}
