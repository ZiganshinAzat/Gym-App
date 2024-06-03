//
//  TrainingHistoryView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 23.05.2024.
//

import UIKit

class TrainingHistoryView: UIView {

    lazy var progressLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Прогресс"
        return label
    }()

    lazy var trainingHistoryTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            TrainingHistoryTableViewCell.self,
            forCellReuseIdentifier: TrainingHistoryTableViewCell.reuseIdentifier
        )
        tableView.backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrainingHistoryView {
    func setupLayout() {
        backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        addSubview(progressLabel)
        addSubview(trainingHistoryTableView)

        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            trainingHistoryTableView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 10),
            trainingHistoryTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            trainingHistoryTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trainingHistoryTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
