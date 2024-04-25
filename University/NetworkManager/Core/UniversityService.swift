//
//  UniversityService.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 18.04.2024.
//


import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    private let networkManager = NetworkManager.shared
    
    func fetchUniversities<T: Decodable>(pageNumber: Int, completion: @escaping (Result<T, Error>) -> Void) {
        networkManager.fetchPage(pageNumber: pageNumber, completion: completion)
    }
    func fetchUniversitiesInProvince(province: String, completion: @escaping (Result<[University], Error>) -> Void) {
        var pageNumber = 1 
        var allUniversities: [University] = []
        
        func fetchNextPage() {
            networkManager.fetchPage(pageNumber: pageNumber) { (result: Result<UniversitiesModel, Error>) in
                switch result {
                case .success(let universitiesModel):
                    if let universities = universitiesModel.data?.first(where: { $0.province == province })?.universities {
                        allUniversities.append(contentsOf: universities)
                    }
                    // Eğer son sayfaya ulaşılmadıysa bir sonraki sayfayı iste
                    if pageNumber < universitiesModel.totalPage ?? 0 {
                        pageNumber += 1
                        fetchNextPage()
                    } else {
                        // Tüm sayfaları dolaştıktan sonra completion bloğunu çağır ve tüm üniversiteleri döndür
                        completion(.success(allUniversities))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        // İlk sayfayı çağır
        fetchNextPage()
    }

    
}



