import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.dynamicFramework(
    name: "ThirdPartyLib",
    packages: [
        .RxSwift,
        .RxFlow,
        .Realm,
        .Moya,
        .Then,
        .SnapKit,
        .Loaf,
        .Kingfisher,
        .UPCarouselFlowLayout,
        .ReactorKit,
        .FSCalendar,
        .FloatingPanel
    ],
    deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone, .ipad]),
    dependencies: [
        .SPM.RxSwift,
        .SPM.Realm,
        .SPM.RealmSwift,
        .SPM.RxCocoa,
        .SPM.RxFlow,
        .SPM.RxMoya,
        .SPM.Then,
        .SPM.SnapKit,
        .SPM.Loaf,
        .SPM.Kingfisher,
        .SPM.UPCarouselFlowLayout,
        .SPM.ReactorKit,
        .SPM.FSCalendar,
        .SPM.FloatingPanel
    ]
)
