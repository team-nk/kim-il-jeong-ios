import Foundation
import RxSwift
import RxCocoa
import Moya
import RxMoya

final class Service {

    let provider = MoyaProvider<API>()

    func imageUproad(_ image: String) -> Single<NetworkingResult> {
        return provider.rx.request(.imageUproad(image: image))
            .filterSuccessfulStatusCodes()
            .map { _ -> NetworkingResult in
                return .createOk
            }
            .catch {[unowned self] in return .just(setNetworkError($0))}
    }
    func setNetworkError(_ error: Error) -> NetworkingResult {
            print(error)
            print(error.localizedDescription)
            guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fault) }
            return (NetworkingResult(rawValue: status) ?? .fault)
    }
}
