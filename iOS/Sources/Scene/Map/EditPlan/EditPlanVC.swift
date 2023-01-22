import UIKit
import SnapKit
import Then
import MapKit
import RxCocoa
import RxSwift
import CoreLocation

class EditPlanVC: BaseVC {
    var isNewPostDetail = PublishRelay<Bool>()
    let dataModel = BehaviorRelay<MapScheduleList?>(value: nil)
    let cellColor = UIView().then {
        $0.backgroundColor = KimIlJeongColor.purpleColor.color
        $0.layer.cornerRadius = 5
    }
    let titleLabel = UILabel().then {
        $0.text = "대덕대학교 자습"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = KimIlJeongAsset.Color.textColor.color
    }
    private let addressImageView = UIImageView().then {
        $0.image = UIImage(named: "AddressPin")
    }
    let addressLabel = UILabel().then {
        $0.text = "대전광역시 유성구 가정북로 76"
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = KimIlJeongAsset.Color.textColor.color
    }
    let timeLabel = UILabel().then {
        $0.text = "2022-05-02 16:30 ~ 2022-05-02 20:00"
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = KimIlJeongAsset.Color.description.color
    }
    let deleteButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.backGroundColor3.color
        $0.layer.cornerRadius = 10
        $0.setTitle("Delete", for: .normal)
        $0.setTitleColor(KimIlJeongAsset.Color.errorColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    let modifyButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.mainColor.color
        $0.layer.cornerRadius = 10
        $0.setTitle("Modify", for: .normal)
        $0.setTitleColor(KimIlJeongAsset.Color.surfaceColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    private func setUpUI() {
        cellColor.backgroundColor = dataModel.value?.color.colorDistinction()
        titleLabel.text = dataModel.value?.content
        addressLabel.text = dataModel.value?.address
        timeLabel.text =
        transformISO8601(stringDate: dataModel.value?.start_time ?? "") +
        " ~ " + transformISO8601(stringDate: dataModel.value?.end_time ?? "")
    }
    private func notWrittinNew() {
        let modifyVC = ModifyVC()
        let deleteCustomVC = DeleteCustomAlertVC()
        modifyButton.rx.tap.subscribe(onNext: { [self] in
            modifyVC.dataModel.accept(dataModel.value)
            modifyVC.setUpUI()
            if #available(iOS 16.0, *) {
                if let sheet = modifyVC.sheetPresentationController {
                    let id = UISheetPresentationController.Detent.Identifier("frist")
                    let detent = UISheetPresentationController.Detent.custom(identifier: id) { _ in
                        return 700
                    }
                    sheet.detents = [detent]
                    sheet.preferredCornerRadius = 32
                    self.present(modifyVC, animated: true)
                }
                modifyVC.isModalInPresentation = true
            }
        }).disposed(by: disposeBag)
        deleteButton.rx.tap.subscribe(onNext: {
            deleteCustomVC.scheduleId = self.dataModel.value?.schedule_id ?? 0
            deleteCustomVC.modalPresentationStyle = .overFullScreen
            deleteCustomVC.modalTransitionStyle = .crossDissolve
            guard let pvc = self.presentingViewController else { return }
            self.dismiss(animated: false) {
                pvc.present(deleteCustomVC, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    private func writeNewPost() {
        isNewPostDetail
            .subscribe(onNext: {
                if $0 == true {
                    self.deleteButton.setTitle("취소하기", for: .normal)
                    self.deleteButton.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
                    self.deleteButton.backgroundColor = .clear
                    self.deleteButton.rx.tap
                        .subscribe(onNext: {
                            self.dismiss(animated: true)
                        }).disposed(by: self.disposeBag)
                    self.modifyButton.setTitle("선택하기", for: .normal)
                    self.modifyButton.rx.tap
                        .subscribe(onNext: {
                            scheduleIDForNew.accept(self.dataModel.value?.schedule_id ?? 0)
                            scheduleContentForNew.accept(self.dataModel.value?.content ?? "일정을 선택해 주세요")
                            self.dismiss(animated: true)
                            isSheetClosed.accept(true)
                        }).disposed(by: self.disposeBag)
                } else {
                    self.notWrittinNew()
                }
            }).disposed(by: disposeBag)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadData (_:)),
            name: NSNotification.Name("reloadData"),
            object: nil
        )
    }
    @objc func reloadData(_ notification: Notification) {
        self.dismiss(animated: true)
    }
    override func configureVC() {
        setUpUI()
        writeNewPost()
    }
    override func addView() {
        [
            cellColor,
            titleLabel,
            addressImageView,
            addressLabel,
            timeLabel,
            deleteButton,
            modifyButton
        ].forEach {view.addSubview($0)}
    }
    override func setLayout() {
        cellColor.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(42)
            $0.width.height.equalTo(10)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalTo(cellColor.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        addressImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(46)
            $0.top.equalTo(titleLabel.snp.bottom)
        }
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(addressImageView.snp.trailing).offset(5)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(12)
        }
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(46)
            $0.trailing.equalToSuperview().inset(139)
            $0.top.equalTo(addressImageView.snp.bottom).offset(6)
        }
        deleteButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo((view.frame.width-60)/2)
            $0.top.equalTo(timeLabel.snp.bottom).offset(38)
            $0.height.equalTo(50)
        }
        modifyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo((view.frame.width-60)/2)
            $0.top.equalTo(timeLabel.snp.bottom).offset(38)
            $0.height.equalTo(50)
        }
    }
}
