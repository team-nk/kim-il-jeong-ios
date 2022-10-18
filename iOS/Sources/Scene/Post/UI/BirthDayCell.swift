//
//  BirthDayCell.swift
//  Kim-Il-Jeong
//
//  Created by 강인혜 on 2022/10/06.
//  Copyright © 2022 com.TeamNK. All rights reserved.
//

import UIKit
import Then
import SnapKit

class BirthDayCell: BaseTC {
    static let id = "BirthDayCell"
    let backView = UIView().then {
        $0.backgroundColor = UIColor(named: "CellBackGroundColor")
        $0.layer.cornerRadius = 20
    }
    let megaphoneImage = UIImageView().then {
        $0.image = UIImage(named: "Megaphone")
    }
    let congratulationsLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "TextColor")
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    let dateLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "Description")
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    override func addView() {
        addSubview(backView)
        [
            megaphoneImage,
            congratulationsLabel,
            dateLabel
        ] .forEach {
            backView.addSubview($0)
        }
    }
    override func configureVC() {
        addView()
        setLayout()
        self.backgroundColor = KimIlJeongColor.backGroundColor2.color
    }
    override func setLayout() {
        megaphoneImage.snp.makeConstraints {
            $0.top.equalTo(backView).inset(28)
            $0.leading.equalTo(backView).inset(17)
            $0.bottom.equalTo(backView).inset(27.28)
            $0.size.width.height.equalTo(24.72)
        }
        congratulationsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(megaphoneImage.snp.trailing).offset(9.82)
            $0.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(congratulationsLabel.snp.bottom).offset(0)
            $0.leading.equalTo(megaphoneImage.snp.trailing).offset(9.82)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(20)
        }
        backView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(0)
            $0.trailing.equalToSuperview().inset(0)
            $0.height.equalTo(80)
        }
    }
}
