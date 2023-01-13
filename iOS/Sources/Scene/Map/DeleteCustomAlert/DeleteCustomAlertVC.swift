import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class DeleteCustomAlertVC: BaseVC {
    var scheduleId = 0
    private let viewModel = DeleteCustomAlertViewModel()
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    private let titleLabel = UILabel().then {
        $0.text = "정말로 삭제하시겠습니까?"
        $0.textColor = KimIlJeongAsset.Color.textColor.color
        $0.font = .systemFont(ofSize: 18, weight: .bold )
        $0.textAlignment = .center
    }
    private let cencelButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.surfaceColor.color
        $0.setTitleColor(KimIlJeongAsset.Color.textColor.color, for: .normal)
        $0.setTitle("취소하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 10
    }
    private let deleteButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.errorColor.color
        $0.setTitleColor(KimIlJeongAsset.Color.surfaceColor.color, for: .normal)
        $0.setTitle("삭제하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 10
    }
    override func bind() {
        let input = DeleteCustomAlertViewModel.Input(
            scheduleId: scheduleId,
            deleteButtonDidTap: deleteButton.rx.tap.asSignal())
        let output = viewModel.transform(input)
        output.deleteResult.subscribe(onNext: { _ in
            self.dismiss(animated: false) {
                NotificationCenter.default.post(
                    name: NSNotification.Name("reloadData"),
                    object: nil,
                    userInfo: nil
                )
            }
        }).disposed(by: disposeBag)
    }

    override func addView() {
        view.addSubview(popupView)
        [
            titleLabel,
            cencelButton,
            deleteButton
        ].forEach {popupView.addSubview($0)}
    }
    override func setLayout() {
        popupView.snp.makeConstraints {
            $0.width.equalTo(328)
            $0.height.equalTo(170)
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(19)
            $0.height.equalTo(40)
        }
        cencelButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.width.equalTo(135)
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().inset(19)
        }
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.width.equalTo(135)
            $0.height.equalTo(50)
            $0.trailing.equalToSuperview().inset(19)
        }
    }
    override func configureVC() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        cencelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
