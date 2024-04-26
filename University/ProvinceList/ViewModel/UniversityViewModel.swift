//
//  UniversityViewModel.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 18.04.2024.
//

import Foundation

class UniversityViewModel {
    private let universtyService = NetworkService.shared
    
    var universities: [University] = []
    
    var universitiesData: [Datum] = []
    
        func fetchUniversities(completion: @escaping () -> Void, failure: @escaping (ErrorMessage) -> Void) {
        let totalPage = 3
        
        for pageNumber in 1...totalPage {
            universtyService.fetchUniversities(pageNumber: pageNumber) { [weak self] (result: Result<UniversitiesModel, Error>) in
                switch result {
                case .success(let universitiesModel):
                    if let data = universitiesModel.data {
                        self?.universitiesData += data
                        self?.universities += data.flatMap { $0.universities ?? [] }
                    } else {
                        failure(ErrorMessage(error: "Invalid university data"))
                    }
                case .failure(let error):
                    failure(ErrorMessage(error: error.localizedDescription))
                }
                if pageNumber == totalPage {
                    completion()
                }
            }
        }
    }
    func fetchUniversityFromProvince(province: String) {
        universtyService.fetchUniversitiesInProvince(province: province) { [weak self] result in
            switch result {
            case .success(let universities):
                self?.universities = universities
            case .failure(let error):
                print("Error fetching universities: \(error.localizedDescription)")
            }
        }
    }
    
    func university(at index: Int) -> University? {
        guard index >= 0 && index < universities.count else {
            return nil
        }
        return universities[index]
    }
    
    func numberOfUniversities() -> Int {
        return universities.count
    }
}


