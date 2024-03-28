//
//  UIColletionViewExtention.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.03.2024.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
