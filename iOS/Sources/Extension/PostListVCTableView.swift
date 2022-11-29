import UIKit

extension PostListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case birthTableView:
            return birthDayList.count

        case scheduleTableView:
            return scheduleList.count

        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case birthTableView:
            if let birthCell = tableView
                .dequeueReusableCell(withIdentifier: "BirthDayCell", for: indexPath) as? BirthDayCell {
                birthCell.congratulationsLabel.text = "\(birthDayList[indexPath.row].username)님의 생일이에요!"
                birthCell.dateLabel.text = "\(birthDayList[indexPath.row].birthDate)"
                birthCell.selectionStyle = .none
                return birthCell
            } else {
                return UITableViewCell()
            }
        case scheduleTableView:
            if let scheduleCell = scheduleTableView
                .dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell {
                scheduleCell.scheduleTitle.text = "\(scheduleList[indexPath.row].title)"
                scheduleCell.scheduleOwner.text = "\(scheduleList[indexPath.row].owner)"
                scheduleCell.scheduleContent.text = "\(scheduleList[indexPath.row].content)"
                scheduleCell.scheduleDate.text = "\(scheduleList[indexPath.row].date)"
                scheduleCell.scheduleLocation.text = "\(scheduleList[indexPath.row].location)"
                scheduleCell.colorSetting.tintColor = UIColor(named: "\(scheduleList[indexPath.row].color)")
                scheduleCell.selectionStyle = .none
                return scheduleCell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case scheduleTableView:
            scheduleTableView.deselectRow(at: indexPath, animated: true)
            let next = PostVC()
            next.postTitleLabel.text = "\(scheduleList[indexPath.row].title)"
            next.colorTag.tintColor = UIColor(named: "\(scheduleList[indexPath.row].color)")
            next.scheduleLabel.text = "\(scheduleList[indexPath.row].content)"
            next.userNameLabel.text = "\(scheduleList[indexPath.row].owner)"
            next.locationLabel.text = "\(scheduleList[indexPath.row].owner)"
            next.dateLabel.text = "\(scheduleList[indexPath.row].date)"
            next.contentTextView.text = "\(scheduleList[indexPath.row].text)"
            navigationController?.pushViewController(next, animated: true)
        default:
            tableView.allowsSelection = false
        }
    }
}
