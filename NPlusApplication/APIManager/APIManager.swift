//
//  APIManager.swift
//  NPlusApplication
//
//  Created by MAC PRO on 15/05/24.
//

import Foundation

class networkManager{
    
    static let shared = networkManager()
    
    private let session : URLSession
    
    private init(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        session = URLSession(configuration: configuration)
    }
    
    func fetchData<T: Codable>(from url: URL, compilition: @escaping(Result<T,Error>)->Void) {
        let task = session.dataTask(with: url){ mydata, myres, myerr in
            if let err = myerr{
                compilition(.failure(err))
                return
            }
            guard let res = myres as? HTTPURLResponse,(200...299).contains(res.statusCode)else{
                let statuscode = (myres as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "Network Error", code: statuscode, userInfo: nil)
                compilition(.failure(error))
                return
            }
            if let data =  mydata{
                do {
                    let decodeObj = try JSONDecoder().decode(T.self, from: data)
                    compilition(.success(decodeObj))
                } catch  {
                    compilition(.failure(error))
                }
            }
        }
        task.resume()
    }
}
