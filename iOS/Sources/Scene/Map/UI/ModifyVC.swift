import UIKit
import SnapKit
import Then
import MapKit
import RxCocoa
import CoreLocation

class ModifyVC: UIViewController {
    private let planChangeLabel = UILabel().then {
        $0.text = "일정 변경하기"
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.textColor = KimIlJeongAsset.Color.textColor.color
    }
    private let titleTextField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
        $0.text = "스타벅스 인수 계약"
        $0.textColor = KimIlJeongAsset.Color.strongExplanation.color
    }
    private let titleUnderLine = UIView().then {
        $0.backgroundColor = KimIlJeongAsset.Color.strongExplanation.color
    }
    private let titleTextStateLabel = UILabel().then {
        $0.text = "11/100"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = KimIlJeongAsset.Color.strongExplanation.color
        $0.textAlignment = .right
    }
    private let addressLabel = UILabel().then {
        $0.text = "대전광역시 둔산동 갤러리아..."
        $0.font = UIFont.systemFont(ofSize: 18, weight: .light)
        $0.textColor = KimIlJeongAsset.Color.strongExplanation.color
    }
    private let serachLocationButton = UIButton(type: .system).then {
        $0.setTitle("위치 검색", for: .normal)
        $0.setTitleColor(KimIlJeongAsset.Color.textColor.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addView()
        setLayout()
    }
    private func addView() {
        [
            planChangeLabel,
            titleTextField,
            titleUnderLine,
            titleTextStateLabel,
            addressLabel,
            serachLocationButton
        ].forEach {view.addSubview($0)}
    }
    private func setLayout() {
        planChangeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(planChangeLabel.snp.bottom).offset(35)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(91)
        }
        titleUnderLine.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10.91)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        titleTextStateLabel.snp.makeConstraints {
            $0.top.equalTo(planChangeLabel.snp.bottom).offset(35)
            $0.leading.equalToSuperview().inset(337)
            $0.trailing.equalToSuperview().inset(30)
        }
        addressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(titleUnderLine.snp.bottom).offset(35)
        }
        serachLocationButton.snp.makeConstraints {
            $0.top.equalTo(titleUnderLine.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
}
