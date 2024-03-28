//
//  IconsViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.03.2024.
//

import UIKit

class IconsViewController: UIViewController {

    var iconsDataSource: [UIImage?]
    let iconsView: IconsView

    init(iconsDataSource: [UIImage?], selectLabelText: String) {
        self.iconsDataSource = iconsDataSource
        iconsView = IconsView(frame: .zero, selectLabelText: selectLabelText)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        view = iconsView
        iconsView.iconsCollectionView.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
}

extension IconsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IconsCollectionViewCell.reuseIdentifier,
            for: indexPath) as? IconsCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configureCell(with: iconsDataSource[indexPath.row])

        return cell
    }
    

}
