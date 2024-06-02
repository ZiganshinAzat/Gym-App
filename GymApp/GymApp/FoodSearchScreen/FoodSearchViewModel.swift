//
//  FoodSearchViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 30.05.2024.
//

import Foundation
import Combine

class FoodSearchViewModel {
    private let foodSearchService: FoodSearchService

    @Published var products: [Product] = []

    init(foodSearchService: FoodSearchService) {
        self.foodSearchService = foodSearchService
    }

    func getProducts(productName: String) async {
        do {
            products = try await foodSearchService.fetchProducts(query: productName)
        }
        catch {
            print("Ошибка getProducts: \(error)")
        }
    }
}
