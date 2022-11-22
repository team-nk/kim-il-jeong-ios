import UIKit

extension MyPageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "MyPageMenuCell", for: indexPath) as? MyPageMenuCell {
            switch indexPath.row {
            case 0:
                cell.menuTitle.text = "생년월일 입력하기 / 수정하기"
            case 1:
                cell.menuTitle.text = "어플리케이션 정보"
            case 2:
                cell.menuTitle.text = "비밀번호 변경하기"
            case 3:
                cell.menuTitle.text = "로그아웃"
                cell.menuTitle.textColor = KimIlJeongColor.errorColor.color
                cell.nextButton.tintColor = KimIlJeongColor.errorColor.color
            default:
                cell.menuTitle.text = nil
            }
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let next = MyBirthSheetVC()
            userMenuTableView.deselectRow(at: indexPath, animated: true)
            self.present(next, animated: true, completion: nil)
        case 3:
                let logOut = LogOutCustomAlertVC()
                logOut.modalPresentationStyle = .overFullScreen
                logOut.modalTransitionStyle = .crossDissolve
                self.present(logOut, animated: true)
        default:
            tableView.allowsSelection = false
        }
    }
}
