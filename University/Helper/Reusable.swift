//
//  Helper.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 24.04.2024.
//

import Foundation
protocol Reusable {
    static var identifier: String {get}
}

extension Reusable {
    static var identifier: String {
        String(describing: self)
    }
}
