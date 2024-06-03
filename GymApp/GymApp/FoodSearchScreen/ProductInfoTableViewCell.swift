//
//  ProductInfoTableViewCell.swift
//  GymApp
//
//  Created by Азат Зиганшин on 01.06.2024.
//

import UIKit
import Kingfisher

class ProductInfoTableViewCell: UITableViewCell {

    lazy var productNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left

        return label
    }()

    lazy var caloriesLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left

        return label
    }()

    lazy var proteinLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left

        return label
    }()

    lazy var fatsLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left

        return label
    }()

    lazy var carbohydratesLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left

        return label
    }()

    lazy var productImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        roundRightCornersOfImageView(productImageView)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductInfoTableViewCell {

    func setupLayout() {
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productImageView)
        contentView.addSubview(caloriesLabel)
        contentView.addSubview(proteinLabel)
        contentView.addSubview(fatsLabel)
        contentView.addSubview(carbohydratesLabel)

        NSLayoutConstraint.activate([

            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            productImageView.leadingAnchor.constraint(equalTo: productNameLabel.trailingAnchor, constant: 5),

            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -150),

            caloriesLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            caloriesLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 10),

            proteinLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            proteinLabel.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: 5),

            fatsLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            fatsLabel.topAnchor.constraint(equalTo: proteinLabel.bottomAnchor, constant: 5),

            carbohydratesLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            carbohydratesLabel.topAnchor.constraint(equalTo: fatsLabel.bottomAnchor, constant: 5)
        ])
    }

    func configureCell(with product: Product, grams: Int) {
        productNameLabel.text = product.name
        let factor = Double(grams) / 100.0
        caloriesLabel.text = "Калории: \(Int(Double(product.calories) * factor)) ккал"
        proteinLabel.text = "Белки: \(Int(Double(product.protein) * factor)) г"
        fatsLabel.text = "Жиры: \(Int(Double(product.fat) * factor)) г"
        carbohydratesLabel.text = "Углеводы: \(Int(Double(product.carbohydrates) * factor)) г"
        productImageView.kf.setImage(with: URL(string: product.imageUrl))
    }

    func roundRightCornersOfImageView(_ imageView: UIImageView) {
        let path = UIBezierPath(roundedRect: imageView.bounds,
                                byRoundingCorners: [.topRight, .bottomRight],
                                cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        imageView.layer.mask = maskLayer
    }
}
