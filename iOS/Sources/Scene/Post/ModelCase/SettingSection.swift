import Foundation

struct BirthDay: Equatable {
    var username: String = .init()
    var birthDate: String = .init()
    let cellType: String = "birthType"
}

struct Schedule: Equatable {
    var color: String = .init()
    var title: String = .init()
    var content: String = .init()
    var owner: String = .init()
    var date: String = .init()
    var location: String = .init()
    let cellType: String = "scheduleType"
}
