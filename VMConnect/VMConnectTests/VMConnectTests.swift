import XCTest
@testable import VMConnect

class VMConnectTests: XCTestCase {
    
    var loginVC: VMCLoginVC!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_EmailValidation() throws{
        //Arrange
        let email = "john@gmail.com"
        //Act
        let isValidEmail = VMCMethods.shared.isValidEmail(emailText: email)
        // Assert
        XCTAssert(isValidEmail, "Email is not valid")
    }
    
    func testloginViewController_Check_TextFields() throws {
        //Check for Initial Empty Value
        XCTAssertEqual(loginVC?.emailTextField?.text ?? "", "", "Failed - Email text field was not empty when the view controller initially loaded")
        XCTAssertEqual(loginVC?.passwordTextField?.text ?? "", "", "Failed - Password text field was not empty when the view controller initially loaded")
    }
    
    func testContactListFetch() throws{
        let expectation = self.expectation(description: "API Call complete")
        VMCApiManager.getContactsData(completion: { message, success, data in
            XCTAssert(success == true, "API Call failed")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5){ error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testRoomListFetch() throws{
        let expectation = self.expectation(description: "API Call complete")
        VMCApiManager.getRoomsData(completion: { message, success, data in
            XCTAssert(success == true, "API Call failed")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5){ error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
