//
//  RoundImageView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.03.2024.
//

import Foundation
import UIKit

class RoundImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
        layer.masksToBounds = true
    }
}
