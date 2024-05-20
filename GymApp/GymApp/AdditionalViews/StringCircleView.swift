//
//  NumberCircleView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 12.03.2024.
//

import UIKit

class StringCircleView: UIView {

    let numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()

    init() {
        super.init(frame: .zero)

        setupLayout()
        backgroundColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}

extension StringCircleView {

    private func setupLayout() {
        addSubview(numberLabel)

        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setupLabel(text: String) {
        self.numberLabel.text = text
    }
}
