//
//  AuthentificationManager.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 22.11.2022.
//

//import Foundation
//import WebKit
//
//class AuthentificationManager {
//    var profileManager = ProfileUserManager()
//    
//    func RequestForCallbackURL(request: URLRequest, completion: @escaping () -> ()) {
//        let requestURLString = (request.url?.absoluteString)! as String
//        print(requestURLString)
//        if requestURLString.hasPrefix(GithubConstants.REDIRECT_URI) {
//            if requestURLString.contains("code=") {
//                if let range = requestURLString.range(of: "=") {
//                    let githubCode = requestURLString[range.upperBound...]
//                    if let range = githubCode.range(of: "&state=") {
//                        let githubCodeFinal = githubCode[..<range.lowerBound]
//                        githubRequestForAccessToken(authCode: String(githubCodeFinal), completion: {})
////                        self.dismiss(animated: true, completion: nil)
//                        completion()
//                    }
//                }
//            }
//        }
//    }
//    
//    func githubRequestForAccessToken(authCode: String, completion: @escaping () -> ()) {
//        let grantType = "authorization_code"
//        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&client_id=" + GithubConstants.CLIENT_ID + "&client_secret=" + GithubConstants.CLIENT_SECRET
//        let postData = postParams.data(using: String.Encoding.utf8)
//        let request = NSMutableURLRequest(url: URL(string: GithubConstants.TOKENURL)!)
//        request.httpMethod = "POST"
//        request.httpBody = postData
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { [self] (data, response, _) -> Void in
//            let statusCode = (response as! HTTPURLResponse).statusCode
//            if statusCode == 200 {
//                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
//                let accessToken = results?["access_token"] as! String
//                profileManager.fetchGitHubUserProfile(accessToken: accessToken, completion: {})
//                completion()
//            }
//        }
//        task.resume()
//    }
//}
