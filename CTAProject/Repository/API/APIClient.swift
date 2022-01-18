//
//  APIClient.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/16.
//

import Foundation

final class APIClient {
    
    func request<T: Requestable>(_ client: T, completion: @escaping(Result<T.ResponseType, APIError>) -> Void) {
        
        let request = URLRequest(url: client.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            guard case 200 ..< 300 = response.statusCode else {
                completion(.failure(.server(response.statusCode)))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try jsonDecoder.decode(T.ResponseType.self, from: data)
                completion(.success(decodedData))
            } catch let decodeError {
                completion(.failure(.decode(decodeError)))
            }
        }
        task.resume()
    }
}
