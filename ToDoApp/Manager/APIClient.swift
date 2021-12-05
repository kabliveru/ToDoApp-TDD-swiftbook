//  Created by Aleksei Korolev

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    lazy var urlSession: URLSessionProtocol = URLSession.shared

    func login(withName name: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
//        let allowedCharacters = CharacterSet.urlQueryAllowed
        guard
            let name = name.percentEncoded, // addingPercentEncoding(withAllowedCharacters: allowedCharacters),
            let password = password.percentEncoded
        else { // addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }

        let query = "name=\(name)&password=\(password)"
        guard let url = URL(string: "https://todoapp.app/login?\(query)") else {
            fatalError()
        }

        urlSession.dataTask(with: url) { data, _, _ in
            guard let data = data else { fatalError() }
            let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
            let token = dictionary["token"]
            completionHandler(token, nil)

        }.resume()
    }
}
