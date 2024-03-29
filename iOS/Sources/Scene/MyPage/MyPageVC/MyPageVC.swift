import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Kingfisher

public var isLogOutTapped = PublishRelay<Bool>()

class MyPageVC: BaseVC {
    private let viewModel = MyPageVM()
    private let getMyInfo = BehaviorRelay<Void>(value: ())
    private let welcomeLabel = UILabel().then {
        $0.text = "Welcome!"
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 34, weight: .bold)
    }
    private let myPageLabel = UILabel().then {
        $0.text = "Mypage"
        $0.textColor = KimIlJeongColor.mainColor.color
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    let profileImage = UIImageView().then {
        $0.layer.cornerRadius = 25
        $0.image = UIImage(named: "NoneProfile")
        $0.clipsToBounds = true
    }
    let userNameLabel = UILabel().then {
        $0.text = "kimdaehee0824"
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    let userEmailLabel = UILabel().then {
        $0.text = "0824dh@naver.com"
        $0.textColor = KimIlJeongColor.description.color
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    private let editButton = UIButton().then {
        $0.setImage(KimIlJeongImage.pencilFill.image, for: .normal)
    }
    let myScheduleButton = UIButton().then {
        $0.backgroundColor = KimIlJeongColor.surface2.color
        $0.layer.cornerRadius = 10
        $0.setTitle("내 일정 확인하기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    }
    let myPostsButton = UIButton().then {
        $0.backgroundColor = KimIlJeongColor.surface2.color
        $0.layer.cornerRadius = 10
        $0.setTitle("내가 쓴 게시물 보기", for: .normal)
        $0.setTitleColor(KimIlJeongColor.textColor.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    }
    let userMenuTableView = ContentWrappingTableView().then {
        $0.register(MyPageMenuCell.self, forCellReuseIdentifier: "MyPageMenuCell")
        $0.rowHeight = 45
        $0.separatorInset.left = 16
        $0.separatorInset.right = 15
        $0.backgroundColor = KimIlJeongColor.backGroundColor2.color
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    override func bind() {
        let input = MyPageVM.Input(getMyInfo: getMyInfo.asDriver())
        let output = viewModel.transform(input)
        output.myInfo
            .subscribe(onNext: {
                self.userNameLabel.text = $0?.accountId
                self.userEmailLabel.text = $0?.email
                guard let imgURL = URL(string: $0?.profile ?? "") else { return }
                self.profileImage.kf.setImage(with: imgURL)
            }).disposed(by: disposeBag)
    }
    override func addView() {
        [
            welcomeLabel,
            myPageLabel,
            profileImage,
            userNameLabel,
            userEmailLabel,
            editButton,
            myScheduleButton,
            myPostsButton,
            userMenuTableView
        ] .forEach {
            view.addSubview($0)
        }
    }
    override func configureVC() {
        self.navigationController?.isNavigationBarHidden = true
        userMenuTableView.dataSource = self
        userMenuTableView.delegate = self
        userMenuTableView.reloadData()
        editButton.rx.tap
            .subscribe(onNext: {
                let next = MyEditVC()
                next.navigationItem.title = "정보 변경하기"
                self.navigationController?.pushViewController(next, animated: true)
            }).disposed(by: disposeBag)
        myScheduleButton.rx.tap
            .subscribe(onNext: {
                let nextVC = DetailMapVC()
                nextVC.navigationController?.isNavigationBarHidden = false
                nextVC.titleLabel.text = " "
                nextVC.plusButton.tintColor = .clear
                nextVC.navigationItem.title = "내 일정 확인하기"
                nextVC.setNavigation()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }).disposed(by: disposeBag)
        myPostsButton.rx.tap
            .subscribe(onNext: {
                let nextVC = MyPostVC()
                nextVC.navigationItem.title = "내 글 확인하기"
                self.navigationController?.pushViewController(nextVC, animated: true)
            }).disposed(by: disposeBag)
        isLogOutTapped.subscribe(onNext: {
            print($0)
            if $0 == true {
                let loginVC = BaseNC(rootViewController: LoginVC())
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    override func setLayout() {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(69)
            $0.leading.equalToSuperview().inset(38)
            $0.height.equalTo(44)
        }
        myPageLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(0)
            $0.leading.equalToSuperview().inset(38)
            $0.height.equalTo(32)
        }
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalTo(myPageLabel.snp.bottom).offset(35)
            $0.leading.equalToSuperview().inset(38)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(myPageLabel.snp.bottom).offset(40)
            $0.height.equalTo(20)
            $0.leading.equalTo(profileImage.snp.trailing).offset(11)
        }
        userEmailLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom)
            $0.height.equalTo(20)
            $0.leading.equalTo(profileImage.snp.trailing).offset(11)
        }
        editButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalTo(myPageLabel.snp.bottom).offset(45)
            $0.trailing.equalToSuperview().inset(47)
        }
        myScheduleButton.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(25)
            if view.frame.width < 400 {
                $0.width.equalTo(166)
            } else {
                $0.width.equalTo(186)
            }
            $0.leading.equalToSuperview().inset(23)
            $0.height.equalTo(45)
        }
        myPostsButton.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(25)
            $0.leading.equalTo(myScheduleButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(45)
        }
        userMenuTableView.snp.makeConstraints {
            $0.top.equalTo(myScheduleButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(23)
        }
    }
}
