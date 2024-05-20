//
//  IconsView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.03.2024.
//

import UIKit

class IconsView: UIView {

    lazy var selectLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center

        return label
    }()

    lazy var iconsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let table = UICollectionView(frame: .zero, collectionViewLayout: layout)
        table.showsHorizontalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.register(IconsCollectionViewCell.self, forCellWithReuseIdentifier: IconsCollectionViewCell.reuseIdentifier)
        table.backgroundColor = UIColor(red: 8/255, green: 10/255, blue: 23/255, alpha: 1.0)

        return table
    }()

    init(frame: CGRect, selectLabelText: String) {
        super.init(frame: frame)
        selectLabel.text = selectLabelText
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IconsView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.width / 3)
    }

    func setupLayout() {
        backgroundColor = UIColor(red: 8/255, green: 10/255, blue: 23/255, alpha: 1.0)

        addSubview(selectLabel)
        addSubview(iconsCollectionView)

        NSLayoutConstraint.activate([
            selectLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            selectLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            iconsCollectionView.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 50),
            iconsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
