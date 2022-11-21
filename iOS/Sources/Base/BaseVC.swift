//
//  baseVC.swift
//  solvedAC
//
//  Created by baegteun on 2021/10/29.
//

import UIKit
import RxSwift
class BaseVC: UIViewController {
    let bound = UIScreen.main.bounds
    typealias KimIlJeongColor = KimIlJeongAsset.Color
    typealias KimIlJeongImage = KimIlJeongAsset.Assets
    var disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = KimIlJeongColor.backGroundColor2.color
        configureVC()
        bind()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addView()
        setLayout()
    }

    func addView() {}
    func setLayout() {}
    func configureVC() {}
    func bind() {}
}
