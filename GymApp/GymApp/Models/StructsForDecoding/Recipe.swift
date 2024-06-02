//
//  Recipe.swift
//  GymApp
//
//  Created by Азат Зиганшин on 01.06.2024.
//

import Foundation

struct Recipe: Decodable {
    let name: String?
    let thumbnailURL: String?
    let nutrition: Nutrition?

    private enum CodingKeys: String, CodingKey {
        case name
        case thumbnailURL = "thumbnail_url" // настройте соответствие здесь
        case nutrition
    }
}


