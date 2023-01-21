import UIKit
import SnapKit
import Then
import RxCocoa
import FloatingPanel

public let isSheetClosed = BehaviorRelay<Bool>(value: false)

class DetailMapVC: BaseVC {
    private let viewAppear = PublishRelay<Void>()
    private let viewModel = DetailMapViewModel()
    private let nextData = BehaviorRelay<MapScheduleList?>(value: nil)
    var isNewPost = BehaviorRelay<Bool>(value: false)
    let titleLabel = UILabel().then {
        $0.textColor = KimIlJeongAsset.Color.textColor.color
        $0.text = "오늘 일정"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    let plusButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = KimIlJeongAsset.Color.textColor.color
    }
    let detailLocationTabelView = UITableView().then {
        $0.register(DetailLocationTableViewCell.self, forCellReuseIdentifier: "DetailLocationTableViewCell")
        $0.backgroundColor = KimIlJeongAsset.Color.backGroundColor2.color
        $0.rowHeight = 60
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    override func viewWillAppear(_ animated: Bool) {
        viewAppear.accept(())
    }
    override func bind() {
        let input = DetailMapViewModel.Input(
            viewAppear: viewAppear.asSignal(),
            selectedIndex: detailLocationTabelView.rx.itemSelected.asSignal())
        let output = viewModel.transform(input)
        output.myMapSchedules
            .bind(to: detailLocationTabelView.rx.items(
                cellIdentifier: "DetailLocationTableViewCell",
                cellType: DetailLocationTableViewCell.self)) { _, item, cell in
            switch item.color {
            case "RED":
                cell.tableColor.backgroundColor = KimIlJeongColor.redTag.color
            case "YELLOW":
                cell.tableColor.backgroundColor = KimIlJeongColor.yellowTag.color
            case "GREEN":
                cell.tableColor.backgroundColor = KimIlJeongColor.greenTag.color
            case "PURPLE":
                cell.tableColor.backgroundColor = KimIlJeongColor.purpleTag.color
            default:
                cell.tableColor.backgroundColor = KimIlJeongColor.blueTag.color
            }
            cell.titleLabel.text = item.content
            cell.subTitleLabel.text = item.address
        }.disposed(by: disposeBag)
        output.nextData
            .subscribe(onNext: { data in
                self.nextData.accept(data.self)
            }).disposed(by: disposeBag)
        detailLocationTabelView.rx.itemSelected
            .subscribe(onNext: { _ in
                self.cellDidTap()
            }).disposed(by: disposeBag)
    }
    private func cellDidTap() {
        let editPlanVC = EditPlanVC()
        editPlanVC.dataModel.accept(self.nextData.value)
        if #available(iOS 16.0, *) {
            if let sheet = editPlanVC.sheetPresentationController {
                let id = UISheetPresentationController.Detent.Identifier("frist")
                let detent = UISheetPresentationController.Detent.custom(identifier: id) { _ in
                    return 220
                }
                sheet.detents = [detent]
                sheet.preferredCornerRadius = 32
                self.present(editPlanVC, animated: true)
            }
        }
        editPlanVC.isModalInPresentation = true
        editPlanVC.isNewPostDetail.accept(self.isNewPost.value)
    }
    override func configureVC() {
        self.navigationController?.isNavigationBarHidden = false
        isSheetClosed
            .subscribe(onNext: {
                if $0 == true {
                    self.dismiss(animated: true)
                } else {
                    print($0)
                }
            }).disposed(by: disposeBag)
    }
    override func addView() {
        [
            plusButton,
            titleLabel,
            detailLocationTabelView
        ].forEach {view.addSubview($0)}
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(35)
            $0.leading.equalToSuperview().inset(34)
        }
        plusButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(29)
            $0.top.equalToSuperview().inset(35)
            $0.width.height.equalTo(28)
        }
        detailLocationTabelView.snp.makeConstraints {
            $0.top.equalTo(plusButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview().inset(23)
        }
    }
}
