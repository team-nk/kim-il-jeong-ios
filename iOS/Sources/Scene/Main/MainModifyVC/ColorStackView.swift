import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ColorStackView: UIStackView {
    private let disposeBag = DisposeBag()
    let color = BehaviorRelay<String>(value: "RED")
    let redColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.errorColor.color
        $0.layer.cornerRadius = 12.5
        $0.tintColor = KimIlJeongAsset.Color.surfaceColor.color
    }
    let blueColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.mainColor.color
        $0.layer.cornerRadius = 12.5
        $0.tintColor = KimIlJeongAsset.Color.surfaceColor.color
    }
    let yellowColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.yellowColor.color
        $0.layer.cornerRadius = 12.5
        $0.tintColor = KimIlJeongAsset.Color.surfaceColor.color
    }
    let greenColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.greenColor.color
        $0.layer.cornerRadius = 12.5
        $0.tintColor = KimIlJeongAsset.Color.surfaceColor.color
    }
    let purpleColorButton = UIButton(type: .system).then {
        $0.backgroundColor = KimIlJeongAsset.Color.purpleColor.color
        $0.layer.cornerRadius = 12.5
        $0.tintColor = KimIlJeongAsset.Color.surfaceColor.color
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        [
            redColorButton,
            blueColorButton,
            yellowColorButton,
            greenColorButton,
            purpleColorButton
        ].forEach { button in
            button.rx.tap.subscribe(onNext: {
                switch button {
                case self.redColorButton:
                    self.color.accept("RED")
                case self.blueColorButton:
                    self.color.accept("BLUE")
                case self.yellowColorButton:
                    self.color.accept("YELLOW")
                case self.greenColorButton:
                    self.color.accept("GREEN")
                default:
                    self.color.accept("PURPLE")
                }
            }).disposed(by: disposeBag)
        }
        color.subscribe(onNext: { [self] in
            [
                redColorButton,
                blueColorButton,
                yellowColorButton,
                greenColorButton,
                purpleColorButton
            ].forEach { $0.setImage(.none, for: .normal)}
            switch $0 {
            case "RED":
                redColorButton.setCheckImage()
            case "BLUE":
                blueColorButton.setCheckImage()
            case "YELLOW":
                yellowColorButton.setCheckImage()
            case "GREEN":
                greenColorButton.setCheckImage()
            default:
                purpleColorButton.setCheckImage()
            }
        }).disposed(by: disposeBag)
    }

    override func layoutSubviews() {
        [
            redColorButton,
            blueColorButton,
            yellowColorButton,
            greenColorButton,
            purpleColorButton
        ].forEach { addSubview($0) }

        redColorButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        blueColorButton.snp.makeConstraints {
            $0.leading.equalTo(redColorButton.snp.trailing).offset(8)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        yellowColorButton.snp.makeConstraints {
            $0.leading.equalTo(blueColorButton.snp.trailing).offset(8)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        greenColorButton.snp.makeConstraints {
            $0.leading.equalTo(yellowColorButton.snp.trailing).offset(8)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        purpleColorButton.snp.makeConstraints {
            $0.leading.equalTo(greenColorButton.snp.trailing).offset(8)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(25)
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
