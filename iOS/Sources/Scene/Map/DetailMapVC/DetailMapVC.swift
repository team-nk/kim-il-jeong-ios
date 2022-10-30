import UIKit
import SnapKit
import Then
import RxCocoa

class DetailMapVC: BaseVC {
    private let titleLabel = UILabel().then {
        $0.textColor = KimIlJeongAsset.Color.textColor.color
        $0.text = "오늘 일정"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    private let plusButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = KimIlJeongAsset.Color.textColor.color
    }
    private let detailLocationTabelView = UITableView().then {
        $0.register(DetailLocationTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func configureVC() {
        tableViewSetting()
     }
    private func tableViewSetting() {
        detailLocationTabelView.delegate = self
        detailLocationTabelView.dataSource = self
        detailLocationTabelView.rowHeight = 60
        detailLocationTabelView.separatorStyle = .none
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
extension DetailMapVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? DetailLocationTableViewCell
        else {
            return UITableViewCell()
        }
        cell.titleLabel.text = "네이버 비전계획팀 미팅"
        cell.subTitleLabel.text = "대전광역시 둔산동 갤러리아읍 둔산 스타벅스"
        cell.tableColor.backgroundColor = KimIlJeongColor.purpleColor.color
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editPlanVC = EditPlanVC()
        if #available(iOS 16.0, *) {
            if let sheet = editPlanVC.sheetPresentationController {
                let id = UISheetPresentationController.Detent.Identifier("frist")
                let detent = UISheetPresentationController.Detent.custom(identifier: id) { _ in
                    return 220
                }
                sheet.detents = [detent]
                sheet.largestUndimmedDetentIdentifier = id
                sheet.preferredCornerRadius = 32
                self.present(editPlanVC, animated: true)
            }

        }
    }
}
