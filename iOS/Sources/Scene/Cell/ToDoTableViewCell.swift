//
//  toDoTableVIewCell.swift
//  Kim-Il-Jeong
//
//  Created by 홍승재 on 2022/10/10.
//  Copyright © 2022 com.TeamNK. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ToDoTableViewCell: UITableViewCell {
    var scheduleId = 0
    var color = ""
    var isAlways = false
    var startTime = ""
    var endTime = ""
    var address = ""
    typealias KimIlJeongColor = KimIlJeongAsset.Color
    static let cellID = "CellID"
    let dateLabel = UILabel().then {
        $0.textColor = KimIlJeongColor.description.color
        $0.font = .systemFont(ofSize: 8, weight: .regular)
    }
    let colorDot = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
    }
    let toDoTitle = UILabel().then {
        $0.textColor = KimIlJeongColor.textColor.color
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        [dateLabel, colorDot, toDoTitle].forEach { self.addSubview($0) }
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func layout() {
        colorDot.snp.makeConstraints {
            $0.left.equalTo(self).inset(10)
            $0.top.equalTo(self).inset(27)
            $0.width.height.equalTo(10)
        }
        toDoTitle.snp.makeConstraints {
            $0.left.equalTo(colorDot.snp.right).inset(-15)
            $0.centerY.equalTo(colorDot)
        }
        dateLabel.snp.makeConstraints {
            $0.left.equalTo(toDoTitle.snp.left)
            $0.bottom.equalTo(toDoTitle.snp.top)
        }
    }
}
