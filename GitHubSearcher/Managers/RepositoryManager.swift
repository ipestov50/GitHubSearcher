//
//  RepositoryManager.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 24.11.2022.
//

import Foundation

class RepositoryManager {
    private let sort = "stars"
    static let shared = RepositoryManager()
    
    func find(perPage: Int = 30, sinceId: Int? = nil, query: String, completion: @escaping (Result<[Repository], NetworkRequest.RequestError>) -> Void) {
        
        let searchQuery = query.replacingOccurrences(of: " ", with: "%20")

        let url = "https://api.github.com/search/repositories?q=\(searchQuery)&per_page=30&sort=\(sort)&page=\(perPage)&order=desc&since=daily"
        
        let session = URLSession(configuration: .default)

        session.dataTask(with: URL(string: url)!) { data, response, error in

            guard URL(string: url) != nil else {
                completion(.failure(.invalidResponse))
                return
            }

            if let _ = error {
                completion(.failure(.networkCreationError))
                return
            }

            guard let jsonData = data else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.sessionExpired))
                return
            }

            do {
                let result = try JSONDecoder().decode(Results.self, from: jsonData)
                DispatchQueue.main.async {
                    let repository = result.items
                    completion(.success(repository!))
                    print(result.items!)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
            }
        }
        .resume()
    }
 }
    
