//
//  BaseTC.swift
//  Kim-Il-Jeong
//
//  Created by 강인혜 on 2022/10/11.
//  Copyright © 2022 com.TeamNK. All rights reserved.
//

import UIKit

class BaseTC: UITableViewCell {
    typealias KimIlJeongColor = KimIlJeongAsset.Color
    typealias KimIlJeongImage = KimIlJeongAsset.Assets

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addView()
        self.setLayout()
        self.configureVC()
    }
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addView() {}
    func setLayout() {}
    func configureVC() {}

}
