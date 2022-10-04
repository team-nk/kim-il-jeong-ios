//
//  baseVC.swift
//  solvedAC
//
//  Created by baegteun on 2021/10/29.
//

import UIKit
import ReactorKit

class BaseVC<T: Reactor>: UIViewController {
    let bound = UIScreen.main.bounds
    typealias KimIlJeongColor = KimIlJeongAsset.Color
    typealias KimIlJeongImage = KimIlJeongAsset.Assets
    var disposeBag: DisposeBag = .init()

    @available(*, unavailable)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = KimIlJeongColor.backGroundColor.color
        addView()
        setLayout()
        configureVC()
    }

    init(reactor: T) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func addView() {}
    func setLayout() {}
    func configureVC() {}
    func bindView(reactor: T) {}
    func bindAction(reactor: T) {}
    func bindState(reactor: T) {}
}

extension BaseVC: View {
    func bind(reactor: T) {
        bindView(reactor: reactor)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
}
