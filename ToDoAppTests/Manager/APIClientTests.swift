//  Created by Aleksei Korolev

@testable import ToDoApp
import XCTest

class APIClientTests: XCTestCase {
    var sut: APIClient!
    var mockURLSession: MockURLSession!

    override func setUpWithError() throws {
        sut = APIClient()
        let jsonDataStub = "{\"token\": \"tokenString1\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: nil)
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

    // token -> data -> completioHandler -> dataTask -> urlSession
    func testSuccessfulLoginCreatesToken() {
        let tokenExpectation = expectation(description: "Token expectation")
        var caughtToken: String?
        sut.login(withName: "user1", password: "password1") { token, _ in
            caughtToken = token
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 2) { _ in
            XCTAssertEqual(caughtToken, "tokenString1")
        }
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

        private let mockDataTask: MockURLSessionDataTask

        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            mockDataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }

        func dataTask(with url: URL, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTask {
            self.url = url
//            return URLSession.shared.dataTask(with: url)
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }

    class MockURLSessionDataTask: URLSessionDataTask {
        private let data: Data?
        private let urlReseponse: URLResponse?
        private let responseError: Error?

        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?

        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            urlReseponse = urlResponse
            self.responseError = responseError
        }

        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlReseponse, self.responseError)
            }
        }
    }
}
