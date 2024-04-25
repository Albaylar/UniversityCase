//
//  ListViewModel.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 24.04.2024.
//

import Foundation

class ListViewModel  {
    
    private let universtyService = NetworkService.shared
    var universities: [University] = []
    var universitiesData: [Datum] = []
    
}
