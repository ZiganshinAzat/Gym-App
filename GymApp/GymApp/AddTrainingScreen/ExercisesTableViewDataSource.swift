//
//  ExercisesTableViewDataSource.swift
//  GymApp
//
//  Created by Азат Зиганшин on 12.03.2024.
//

import Foundation
import UIKit

class ExercisesTableViewDataSource: NSObject, UITableViewDataSource {

    var dataSource: [String] = ["Тяга к поясу", "Жим лежа", "Присед"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExercisesTableViewCell.reuseIdentifier,
            for: indexPath) as? ExercisesTableViewCell else {
            return UITableViewCell()
        }

        cell.configureCell(title: dataSource[indexPath.row], number: String(indexPath.row + 1))

        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
