import XCTest
@testable import sichallenge

class SIClientTests: XCTestCase {

    func testFetch() {
        
        let client = SIClient()
        let waitExpectation = expectation(withDescription: "Wait for fetch to return.")

        client.fetch(completionHandler: { dictionary in

            // Test the response's basic structure.
            XCTAssertNotNil(dictionary["Id"] as? Int)
            XCTAssertNotNil(dictionary["Name"] as? String)
            XCTAssertNotNil(dictionary["Settings"] as? [String: AnyObject])
            XCTAssertNotNil(dictionary["Players"] as? [[String: AnyObject]])
            
            waitExpectation.fulfill()
        },
        errorHandler: { message in
            
            waitExpectation.fulfill()
            XCTFail(message)
        })
        
        waitForExpectations(withTimeout: 60, handler: nil)
    }
    
    func testFetchFail() {
        
        let client = TestClient()
        let waitExpectation = expectation(withDescription: "Wait for fetch to return.")
        
        client.fetch(completionHandler: { dictionary in
            
            waitExpectation.fulfill()
            XCTFail()
        },
        errorHandler: { message in
                
            waitExpectation.fulfill()
            XCTAssertEqual(message, TestClient.failMessage)
        })
        
        waitForExpectations(withTimeout: 60, handler: nil)
    }
    
    func testPost() {
        
        let client = SIClient()
        let waitExpectation = expectation(withDescription: "Wait for post to return.")
        
        let player = PlayerModel(with: ["Id": 1, "FirstName": "Mariano", "LastName": "Abdala"])
        let team = TeamModel(with: ["Id": 1, "Name": "Eagles"])
        
        client.postPlayerTapped(player, from: team, completionHandler: {
            
            waitExpectation.fulfill()
            
        },
        errorHandler: { message in
        
            waitExpectation.fulfill()
            XCTFail(message)
        })
        
        waitForExpectations(withTimeout: 60, handler: nil)
    }
    
    func testPostFail() {
        
        let client = TestClient()
        let waitExpectation = expectation(withDescription: "Wait for post to return.")
        
        let player = PlayerModel(with: ["Id": 1, "FirstName": "Mariano", "LastName": "Abdala"])
        let team = TeamModel(with: ["Id": 1, "Name": "Eagles"])
        
        client.postPlayerTapped(player, from: team, completionHandler: {
            
            waitExpectation.fulfill()
            XCTFail()
        },
        errorHandler: { message in
        
            waitExpectation.fulfill()
            XCTAssertEqual(message, TestClient.failMessage)
        })
        
        waitForExpectations(withTimeout: 60, handler: nil)
    }
}

class TestClient: Client {

    static let failMessage = "FAILURE"
    
    func fetch(completionHandler: ([String : AnyObject]) -> (), errorHandler: (message: String) -> ()) {
        
        errorHandler(message: TestClient.failMessage)
    }
    
    func postPlayerTapped(_ player: PlayerModel, from team: TeamModel, completionHandler:() -> (), errorHandler:(message: String) -> ()) {
        
        errorHandler(message: TestClient.failMessage)
    }
}
