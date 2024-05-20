//
//  UITextFieldExtension.swift
//  GymApp
//
//  Created by Азат Зиганшин on 18.05.2024.
//

import Foundation
import UIKit

extension UITextField {
    func applyErrorStyle() {
        self.layer.borderColor = UIColor.red.cgColor
        self.textColor = UIColor.red
    }

    func applyNormalStyle() {
        self.layer.borderColor = UIColor(red: 40/255, green: 42/255, blue: 60/255, alpha: 1.0).cgColor
        self.textColor = .white
    }
}
