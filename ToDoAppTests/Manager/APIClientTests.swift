//  Created by Алексей Королев

@testable import ToDoApp
import XCTest

class APIClientTests: XCTestCase {
    var sut: APIClient!
    var mockURLSession: MockURLSession!

    override func setUpWithError() throws {
        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.urlSession = mockURLSession
    }

    override func tearDownWithError() throws {
        sut = nil
        mockURLSession = nil
    }

    func userLogin() {
        let completionHandler = { (_: String?, _: Error?) in }
        sut.login(withName: "user1", password: "password1%", completionHandler: completionHandler)
    }

    func testLoginUsesCorrectHost() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoapp.app")
    }

    func testLoginUsesCorrectPath() {
        userLogin()
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }

    func testLoginUsesWxpectedQueryParameters() {
        userLogin()

        guard let queryItems = mockURLSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        let urlQueryItemName = URLQueryItem(name: "name", value: "user1")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "password1%")

        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
}

extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }

        func dataTask(with url: URL, completionHandler _: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            return URLSession.shared.dataTask(with: url)
        }
    }
}
