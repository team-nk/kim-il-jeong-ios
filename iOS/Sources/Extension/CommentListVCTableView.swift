import UIKit
extension CommentListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
            cell.commentLabel.text = "\(commentArray[indexPath.row].content)"
            cell.userLabel.text = "\(commentArray[indexPath.row].accountId)"
            cell.commentDateLabel.text = "\(commentArray[indexPath.row].createTime)"
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}
