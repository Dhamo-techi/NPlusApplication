//
//  PostViewModel.swift
//  NPlusApplication
//
//  Created by MAC PRO on 23/05/24.
//

import Foundation

class APIService {
    
    private let baseURL = "https://dummyjson.com/posts"
    
    func fetchPosts(page: Int, limit: Int, completion: @escaping (Result<PostModel, Error>) -> Void) {
        let urlString = "\(baseURL)?page=\(page)&limit=\(limit)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 204, userInfo: nil)))
                return
            }
            do {
                let posts = try JSONDecoder().decode(PostModel.self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
