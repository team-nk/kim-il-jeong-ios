import Foundation
import RxSwift
import RxCocoa
import Moya
import RxMoya
// swiftlint:disable line_length
final class Service {

    let provider = MoyaProvider<API>(plugins: [MoyaLoggingPlugin()])

    func imageUproad(_ image: String) -> Single<NetworkingResult> {
        return provider.rx.request(.imageUproad(image: image))
            .filterSuccessfulStatusCodes()
            .map { _ -> NetworkingResult in
                return .createOk
            }
            .catch {[unowned self] in return .just(setNetworkError($0))}
    }

    func login(_ email: String, _ password: String) -> Single<NetworkingResult> {
        return provider.rx.request(.login(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(TokenModel.self)
            .map { response -> NetworkingResult in
                Token.accessToken = response.access_token
                Token.refreshToken = response.refresh_token
                return .getOk
            }
            .catch {[unowned self] in return .just(setNetworkError($0))}
    }

    func signUp(_ email: String, _ code: String, _ accountId: String, _ password: String, _ rePassword: String) -> Single<NetworkingResult> {
        return provider.rx.request(.signup(email: email, code: code, accountId: accountId, password: password, rePassword: rePassword))
            .filterSuccessfulStatusCodes()
            .map {_ -> NetworkingResult in
                return .createOk
            }
            .catch {[unowned self] in return .just(setNetworkError($0))}
    }

    func sendEmail(_ email: String) -> Single<NetworkingResult> {
        return provider.rx.request(.sendEmail(email: email))
            .filterSuccessfulStatusCodes()
            .map {_ -> NetworkingResult in
                return .getOk
            }
            .catch {[unowned self] in return .just(setNetworkError($0))}
    }

    func codeCheck(_ email: String, _ code: String) -> Single<NetworkingResult> {
        return provider.rx.request(.codeCheck(email: email, code: code))
            .filterSuccessfulStatusCodes()
            .map {_ -> NetworkingResult in
                return .getOk
            }
            .catch {[unowned self] in return .just(setNetworkError($0))}
    }
    func idCheck(_ accountId: String) -> Single<NetworkingResult> {
        return provider.rx.request(.idCheck(accountId: accountId))
            .filterSuccessfulStatusCodes()
            .map {_ -> NetworkingResult in
                return .getOk
            }
            .catch {[unowned self] in return .just(setNetworkError($0))}
    }
    // Post
    func fetchBirthdayUsers() -> Single<(BirthdayListModel?, NetworkingResult)> {
        return provider.rx.request(.getBirthdayUsers)
            .filterSuccessfulStatusCodes()
            .map(BirthdayListModel.self)
            .map { return ($0, .getOk)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    func fetchAllPosts() -> Single<(PostListModel?, NetworkingResult)> {
        return provider.rx.request(.getAllSchedules)
            .filterSuccessfulStatusCodes()
            .map(PostListModel.self)
            .map { return ($0, .getOk)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    func refreshToken() -> Single<NetworkingResult> {
        return provider.rx.request(.refreshToken)
            .filterSuccessfulStatusCodes()
            .map(TokenModel.self)
            .map { response -> NetworkingResult in
                Token.accessToken = response.access_token
                Token.refreshToken = response.refresh_token
                return .getOk
            }
            .catch {[unowned self] in return .just(setNetworkError($0))}
    }
    func getMySchedules() -> Single<(MySchedulesModel?, NetworkingResult)> {
        return provider.rx.request(.getMySchedule)
            .filterSuccessfulStatusCodes()
            .map(MySchedulesModel.self)
            .map { return ($0, .getOk) }
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    func fetchAllComments(_ postID: Int) -> Single<(CommentModel?, NetworkingResult)> {
        return provider.rx.request(.getAllComments(postId: postID))
            .filterSuccessfulStatusCodes()
            .map(CommentModel.self)
            .map { return ($0, .getOk) }
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    func getMapSchedules() -> Single<(MyMapSchedulesModel?, NetworkingResult)> {
        return provider.rx.request(.getMapSchedule)
            .filterSuccessfulStatusCodes()
            .map(MyMapSchedulesModel.self)
            .map { return ($0, .getOk) }
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    func sendNewComment(_ content: String, _ postID: Int) -> Single<NetworkingResult> {
        return provider.rx.request(.postNewComment(content: content, postId: postID))
            .filterSuccessfulStatusCodes()
            .map { _ -> NetworkingResult in
                return .createOk
            }
            .catch { [unowned self] in return .just(setNetworkError($0))}
    }
    func setNetworkError(_ error: Error) -> NetworkingResult {
            print(error)
            print(error.localizedDescription)
            guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fault) }
            return (NetworkingResult(rawValue: status) ?? .fault)
    }

}
