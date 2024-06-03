//
//  UIImageExtention.swift
//  GymApp
//
//  Created by Азат Зиганшин on 28.03.2024.
//

import Foundation
import UIKit

extension UIImage {

    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
