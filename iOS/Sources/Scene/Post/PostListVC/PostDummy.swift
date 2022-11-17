import Foundation

struct BirthDay {
    var username: String = .init()
    var birthDate: String = .init()
    let cellType: String = "birthType"
}

struct Schedule {
    var color: String = .init()
    var title: String = .init()
    var content: String = .init()
    var owner: String = .init()
    var date: String = .init()
    var location: String = .init()
    var text: String = .init()
    let cellType: String = "scheduleType"
}

class Dummies {
    // BirthDaySection
    let birthItem1 = BirthDay.self(username: "Daehee", birthDate: "2022-08-22")
    let birthItem2 = BirthDay.self(username: "younhee0824", birthDate: "2022-08-24")
    let birthItem3 = BirthDay.self(username: "Kimdaehee0824", birthDate: "2022-08-24")
    let birthItem4 = BirthDay.self(username: "dlsgP08", birthDate: "2022-08-26")
    // PostListSection
    let scheduleItem1 = Schedule.self(
        color: "MainColor", title: "기능정의서 구체화",
        content: "재미있는 노션 공부 시간", owner: "wkdtjrdus05",
        date: "2022-08-02", location: "광주광역시 농성동 농성제일파크",
        text: "이번에 스타벅스 둔산점을 (주)Daehee.corp이 인수하게 되었습니다. 이번 일을 계기로 " +
            "대전시에 위치하고 있는 스타벅스 매장을 CJ로부터 강탈해 보려는 계획을 새겨보려 합니다."
    )
    let scheduleItem2 = Schedule.self(
        color: "ErrorColor", title: "자치 회의를 시작하려 합니다",
        content: "학교 자치 회의", owner: "Kimdaehee0824",
        date: "2022-12-22", location: "대전광역시 유성구 가정북로 76",
        text: "이번에 스타벅스 둔산점을 (주)Daehee.corp이 인수하게 되었습니다. 이번 일을 계기로 " +
            "대전시에 위치하고 있는 스타벅스 매장을 CJ로부터 강탈해 보려는 계획을 새겨보려 합니다."
    )
    let scheduleItem3 = Schedule.self(
        color: "MainColor", title: "국군 의병 선서식 참여하셔야 합니다.",
        content: "의병 선서식", owner: "ROKA-ARMY",
        date: "2024-08-02", location: "충청남도 천안시 현충원 메인광장",
        text: "이번에 스타벅스 둔산점을 (주)Daehee.corp이 인수하게 되었습니다. 이번 일을 계기로 " +
            "대전시에 위치하고 있는 스타벅스 매장을 CJ로부터 강탈해 보려는 계획을 새겨보려 합니다."
    )
    let scheduleItem4 = Schedule.self(
        color: "MainColor", title: "국군 의병 선서식 참여하셔야 합니다.",
        content: "의병 선서식", owner: "ROKA-ARMY",
        date: "2024-08-02", location: "충청남도 천안시 현충원 메인광장",
        text: "이번에 스타벅스 둔산점을 (주)Daehee.corp이 인수하게 되었습니다. 이번 일을 계기로 " +
            "대전시에 위치하고 있는 스타벅스 매장을 CJ로부터 강탈해 보려는 계획을 새겨보려 합니다."
    )
    let scheduleItem5 = Schedule.self(
        color: "YelloColor", title: "Starbucks 인수 결정했습니다!",
        content: "스타벅스 둔산 사전점검", owner: "eogus",
        date: "2022-08-02", location: "대전광역시 둔산동 갤러리아읍 둔산 스타벅스",
        text: "이번에 스타벅스 둔산점을 (주)Daehee.corp이 인수하게 되었습니다. 이번 일을 계기로 " +
            "대전시에 위치하고 있는 스타벅스 매장을 CJ로부터 강탈해 보려는 계획을 새겨보려 합니다."
    )
}
