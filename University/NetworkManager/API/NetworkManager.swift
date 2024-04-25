//
//  NetworkManager.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 18.04.2024.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://storage.googleapis.com/invio-com/usg-challenge/universities-at-turkey"
    
    func fetchPage<T: Decodable>(pageNumber: Int, completion: @escaping (Result<T, Error>) -> Void) {
        let url = "\(baseURL)/page-\(pageNumber).json"
        
        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

