import XCTest
@testable import VMConnect

class VMConnectTests: XCTestCase {
    
    var loginVC: VMCLoginVC!
    
    override func setUpWithError() throws {
    }
    override func tearDownWithError() throws {
    }
    
    func testEmailValidation() throws{
        //Arrange
        let email = "john@gmail.com"
        //Act
        let isValidEmail = VMCMethods.shared.isValidEmail(emailText: email)
        // Assert
        XCTAssert(isValidEmail, "Email is not valid")
    }
    
    func testloginViewControllerCheckTextFields() throws {
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
    }

    func testPerformanceExample() throws {
        measure {
        }
    }
}
