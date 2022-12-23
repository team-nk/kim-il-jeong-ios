import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class MyPostVC: BaseVC {
    var scheduleList: [Schedule] = []
    let dummyList = Dummies()
    let myPostTableView = UITableView().then {
        $0.register(ScheduleCell.self, forCellReuseIdentifier: "MyPostsCell")
        $0.rowHeight = 80
        $0.separatorInset.left = 16
        $0.separatorInset.right = 15
        $0.backgroundColor = KimIlJeongColor.backGroundColor2.color
        $0.showsVerticalScrollIndicator = false
    }
    func addDummyData() {
        scheduleList = [
            dummyList.scheduleItem1, dummyList.scheduleItem2,
            dummyList.scheduleItem3, dummyList.scheduleItem4,
            dummyList.scheduleItem5
        ]
    }
    func setUpTableView() {
        myPostTableView.delegate = self
        myPostTableView.dataSource = self
        myPostTableView.reloadData()
    }
    override func addView() {
        view.addSubview(myPostTableView)
    }
    override func configureVC() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "내 글 확인하기"
        setNavigation()
        addDummyData()
        setUpTableView()
    }
    override func setLayout() {
        myPostTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(23)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}

extension MyPostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = myPostTableView
            .dequeueReusableCell(withIdentifier: "MyPostsCell", for: indexPath) as? ScheduleCell {
            cell.scheduleTitle.text = "\(scheduleList[indexPath.row].title)"
            cell.scheduleOwner.text = "\(scheduleList[indexPath.row].owner)"
            cell.scheduleContent.text = "\(scheduleList[indexPath.row].content)"
            cell.scheduleDate.text = "\(scheduleList[indexPath.row].date)"
            cell.scheduleLocation.text = "\(scheduleList[indexPath.row].location)"
            cell.colorSetting.tintColor = UIColor(named: "\(scheduleList[indexPath.row].color)")
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myPostTableView.deselectRow(at: indexPath, animated: true)
        let next = PostVC()
        next.myPost = true
        next.postTitleLabel.text = "\(scheduleList[indexPath.row].title)"
        next.colorTag.tintColor = UIColor(named: "\(scheduleList[indexPath.row].color)")
        next.scheduleLabel.text = "\(scheduleList[indexPath.row].content)"
        next.userNameLabel.text = "\(scheduleList[indexPath.row].owner)"
        next.locationLabel.text = "\(scheduleList[indexPath.row].owner)"
        next.dateLabel.text = "\(scheduleList[indexPath.row].date)"
        next.contentTextView.text = "\(scheduleList[indexPath.row].text)"
        next.navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(next, animated: true)
    }
}
