//
//  DetailLocationTableViewCell.swift
//  Kim-Il-Jeong
//
//  Created by 박주영 on 2022/10/19.
//  Copyright © 2022 com.TeamNK. All rights reserved.
//

import UIKit
import SnapKit
import Then
class DetailLocationTableViewCell: BaseTC {
    let titleLabel = UILabel().then {
        $0.text = "sdfs"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = KimIlJeongAsset.Color.textColor.color
    }
    let subTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = KimIlJeongAsset.Color.description.color
    }
    let tableColor = UIView().then {
        $0.layer.cornerRadius = 5
    }
    let underLine = UIView().then {
        $0.backgroundColor = KimIlJeongColor.description.color
    }
    override func configureVC() {
    }
    override func addView() {
        [
            titleLabel,
            subTitleLabel,
            tableColor,
            underLine
        ].forEach {addSubview($0)}
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(11)
            $0.top.equalToSuperview().inset(10)
        }
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(11)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(9)
        }
        tableColor.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(10)
        }
        underLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
}
