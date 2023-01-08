import Foundation

struct CommentModel: Codable {
    let commentList: [Comments]
    enum CodingKeys: String, CodingKey {
        case commentList = "comment_list"
    }
}
struct Comments: Codable {
    let content: String
    let accountId: String
    let profile: String
    let createTime: String
    enum CodingKeys: String, CodingKey {
        case content
        case accountId = "account_id"
        case profile
        case createTime = "create_time"
    }
}

struct CommentListModel {
    var commentDummyList = [Comments]()
}

struct CommentDummies {
    var content: String = .init()
    var accountId: String = .init()
    var profile: String = .init()
    var createTime: String = .init()
}

class CommentDummyItems {
    let cmt1 = CommentDummies.self(
        content: "미쳤다... 아니 저거를 사네",
        accountId: "eogus",
        createTime: "2022-08-02 18:12")
    let cmt2 = CommentDummies.self(
        content: "근데 둔산점은 마진이 안남을 텐데.....이거를 인수를 한다고??",
        accountId: "Daehee0001",
        createTime: "2022-08-02 18:20")
    let cmt3 = CommentDummies.self(
        content: """
        이건 혁명이야 \n
        이건 혁명이야 \n
        이건 혁명이야
        """,
        accountId: "Daehee0001",
        createTime: "2022-08-02 18:20")
    let cmt4 = CommentDummies.self(
        content: "미쳤다... 아니 저거를 사네",
        accountId: "eogus0012",
        createTime: "2022-08-02 18:12")
    let cmt5 = CommentDummies.self(
        content: "Wow!!!!",
        accountId: "rudtndl05",
        createTime: "2022-08-02 18:20")
    let cmt6 = CommentDummies.self(
        content: "진짜 미쳤다리",
        accountId: "eogus",
        createTime: "2022-08-02 18:12")
    let cmt7 = CommentDummies.self(
        content: """
        이건 \n
        진짜 \n
        아니다
        """,
        accountId: "tjrdus05",
        createTime: "2022-08-02 18:20")
    let cmt8 = CommentDummies.self(
        content: "아 뭔 Daehee.corp이야 이딴 듣보잡을 내가 어떻게 아냐고요..... 진짜 느낌없네",
        accountId: "daehee0824",
        createTime: "2022-08-02 18:20")
    let cmt9 = CommentDummies.self(
        content: """
        근데 CJ거를 인수를 한다고 해도 과연 이 대전광역시의 시장을 공략해서 계획을 세운건가 싶다.... 이렇게 해버리면 대전광역시 말고도 다른 곳들도 인수될 가능성이 있지 않나?
        """,
        accountId: "rlaeogml005",
        createTime: "2022-08-02 18:12")
    let cmt10 = CommentDummies.self(
        content: "나는 진짜 잘 모르겠다.....",
        accountId: "tjrdus05",
        createTime: "2022-08-02 18:20")
    let cmt11 = CommentDummies.self(
        content: "아 난 모르겠다 ㅋㅋ",
        accountId: "justinlee05",
        createTime: "2022-08-02 18:20")
    let cmt12 = CommentDummies.self(
        content: "lfjsdfksdlfjsldfisjdflisdfslfisdflsjdfsildfsldifsjflsifsjldfisjdflejlrbqkerhqwerhqkw" +
        "erhljfhqelfhfafyiufdafdbflhjsvdfadyfzdsyfiapeyriqo3rkerbjeftdfysjfslkjfsalkfuoauror4ljrlqekerqurlqer" +
        "erhljfhqelfhfafyiufdafdbflhjsvdfadyfzdsyfiapeyriqo3rkerbjeftdfysjfslkjfsalkfuoauror4ljrlqekerqurlqerfu",
        accountId: "dlsgP08",
        createTime: "2022-11-18 20:00"
    )
}
