import XCTest
@testable import Danger

class GitHubTests: XCTestCase {
    static var allTests = [
        ("test_GitHubUser_decode", test_GitHubUser_decode),
        ("test_GitHubMilestone_decodeWithSomeParameters", test_GitHubMilestone_decodeWithSomeParameters),
        ("test_GitHubMilestone_decodeWithAllParameters", test_GitHubMilestone_decodeWithAllParameters),
    ]
    
    func test_GitHubUser_decode() throws {
        guard let data = GitHubUserJSON.data(using: .utf8) else {
            XCTFail("Cannot generate data")
            return
        }
        
        let correctUser = GitHubUser(id: 25879490, login: "yhkaplan", userType: .user)
        let testUser: GitHubUser = try JSONDecoder().decode(GitHubUser.self, from: data)
        
        XCTAssertEqual(testUser, correctUser)
    }
    
    func test_GitHubMilestone_decodeWithSomeParameters() throws {
        // This is only a temporary hack
        // TODO: move Danger.swift's date formatter to Date extension
        // with its own test
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        guard let data = GitHubMilestoneJSONWithSomeParameters.data(using: .utf8),
        let createdAt = dateFormatter.date(from: "2018-01-20T16:29:28Z"),
            let updatedAt = dateFormatter.date(from: "2018-02-27T06:23:58Z") else {
            XCTFail("Cannot generate data")
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let milestone: GitHubMilestone = try decoder.decode(GitHubMilestone.self, from: data)
        let creator = GitHubUser(id: 739696, login: "rnystrom", userType: .user)
        
        XCTAssertNil(milestone.closedAt)
        XCTAssertEqual(milestone.closedIssues, 2)
        XCTAssertEqual(milestone.createdAt, createdAt)
        XCTAssertEqual(milestone.creator, creator)
        XCTAssertEqual(milestone.description, "kdsjfls")
        XCTAssertNil(milestone.dueOn)
        XCTAssertEqual(milestone.id, 3050458)
        XCTAssertEqual(milestone.number, 11)
        XCTAssertEqual(milestone.openIssues, 0)
        XCTAssertEqual(milestone.state, GitHubMilestone.MilestoneState.open)
        XCTAssertEqual(milestone.title, "1.19.0")
        XCTAssertEqual(milestone.updatedAt, updatedAt)
    }
    
    func test_GitHubMilestone_decodeWithAllParameters() throws {
        
    }
}

// TODO: Delete this implementation when Swift 4.1 comes out
extension GitHubUser: Equatable {
    public static func ==(lhs: GitHubUser, rhs: GitHubUser) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.userType == rhs.userType &&
            lhs.login == rhs.login
    }
}
