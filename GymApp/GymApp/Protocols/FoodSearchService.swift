//
//  FoodSearchService.swift
//  GymApp
//
//  Created by Азат Зиганшин on 01.06.2024.
//

import Foundation

protocol FoodSearchService {

    func fetchProducts(query: String) async throws -> [Product]
}
