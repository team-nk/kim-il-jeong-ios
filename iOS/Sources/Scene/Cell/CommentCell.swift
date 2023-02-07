import UIKit
import SnapKit
import Then

class CommentCell: BaseTC {
    private let backView = UIView().then {
        $0.backgroundColor = .clear
    }
    let commentLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.textColor = KimIlJeongColor.textColor.color
        $0.textAlignment = .natural
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 0
    }
    let userLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.textColor.color
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 8, weight: .semibold)
    }
    let commentDateLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.description.color
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 8, weight: .regular)
    }
    let profileImage = UIImageView().then {
        $0.image = UIImage(named: "NoneProfile")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    override func addView() {
        addSubview(backView)
        [
            commentLabel,
            profileImage,
            userLabel,
            commentDateLabel
        ] .forEach {
            backView.addSubview($0)
        }
    }
    override func setLayout() {
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview()
        }
        commentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(6)
            $0.trailing.equalToSuperview().inset(110)
        }
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.trailing.equalToSuperview().inset(4)
        }
        userLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.height.equalTo(10)
            $0.trailing.equalToSuperview().inset(29)
        }
        commentDateLabel.snp.makeConstraints {
            $0.top.equalTo(userLabel.snp.bottom).offset(0)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(10)
        }
    }
}
