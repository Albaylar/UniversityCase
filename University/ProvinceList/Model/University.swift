//
//  University.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 18.04.2024.
//

import Foundation

// MARK: - UniversitiesModel
struct UniversitiesModel: Codable {
    let currentPage, totalPage, total, itemPerPage: Int?
    let pageSize: Int?
    var data: [Datum]?
    }

// MARK: - Datum
struct Datum: Codable {
    let id: Int?
    let province: String?
    var universities: [University]?
    var isExpanded: Bool?
    
}

// MARK: - University
struct University: Codable {
    let name, phone, fax: String?
    let website: String?
    let email, adress, rector: String?
    var isExpanded: Bool?
}
