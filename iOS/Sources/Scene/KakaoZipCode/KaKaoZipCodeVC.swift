import UIKit
import WebKit
import RxSwift
import RxCocoa
import SnapKit

class KakaoZipCodeVC: UIViewController {

    // MARK: - Properties
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    var address = ""

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        configureUI()
    }
    override func viewWillLayoutSubviews() {
        setContraints()
    }
    private func configureUI() {
        view.backgroundColor = .white
        self.webView?.navigationDelegate = self
        guard let url = URL(string: "https://kasroid.github.io/Kakao-Postcode/"),
            let webView = webView
            else { return }
        let request = URLRequest(url: url)
        webView.load(request)

        indicator.startAnimating()
    }

    private func setAttributes() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
    }
    // MARK: - UI
    private func setContraints() {
        guard let webView = webView else { return }
        view.addSubview(webView)
        webView.addSubview(indicator)
        webView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension KakaoZipCodeVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            address = data["roadAddress"] as? String ?? ""
        }
        let preVC = self.presentingViewController
        guard let mainModifyVC = preVC as? MainModifyVC else {
            return
        }
        mainModifyVC.address.accept(self.address)
        self.presentingViewController?.dismiss(animated: true)
    }
}

extension KakaoZipCodeVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
