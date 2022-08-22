import ProjectDescription

public enum Environment {
    public static let appName = "kim-il-jeong"
    public static let targetName = "kim-il-jeong"
    public static let targetTestName = "\(targetName)Tests"
    public static let organizationName = "team-nk"
    public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "13.0", devices: [.iphone, .ipad])
    public static let platform = Platform.iOS
    public static let baseSetting: SettingsDictionary = SettingsDictionary()
}
