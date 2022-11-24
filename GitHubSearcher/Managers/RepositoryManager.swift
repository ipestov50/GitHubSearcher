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
    
    func find(query: String, page: Int, completion: @escaping (Result<[Repository]?, NetworkRequest.RequestError>) -> Void) {
        
        let searchQuery = query.replacingOccurrences(of: " ", with: "%20")

        let url = "https://api.github.com/search/repositories?q=\(searchQuery)&per_page=30&sort=\(sort)&page=\(page)&order=desc&since=daily"
        
        let session = URLSession(configuration: .default)

        session.dataTask(with: URL(string: url)! ) { data, response, error in

            guard URL(string: url) != nil else {
                completion(.failure(.networkCreationError))
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
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let repositories = try JSONDecoder().decode(Results.self, from: jsonData)
                // appending to searched Repositories...
                DispatchQueue.main.async {
                    // checking if any data already loaded is again loaded...
                    // ignores already loaded
                    completion(.success(repositories.items))
                    print(repositories.items!)
                }
            } catch {
                print(error)

                DispatchQueue.main.async {
                    completion(.failure(.networkCreationError))
                }
            }
        }
        .resume()
    }
 }
    
