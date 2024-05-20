//
//  TrainingProcessView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.04.2024.
//

import UIKit

class TrainingProcessView: UIView {

    lazy var trainingTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Жим"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    lazy var stopwatchLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    lazy var finishTrainingButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Закончить", for: .normal)
        button.backgroundColor = UIColor(red: 205/255.0, green: 87/255.0, blue: 200/255.0, alpha: 1.0)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .heavy)

        let action = UIAction { [weak self] _ in

            if let finishButtonAction = self?.finishTrainingButtonTapped {
                finishButtonAction()
            } else {
                print("Не добавлено событие на кнопку")
            }
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var exercisesTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TrainingProcessTableViewCell.self, forCellReuseIdentifier: TrainingProcessTableViewCell.reuseIdentifier)
        tableView.backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true

        return tableView
    }()

    var finishTrainingButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrainingProcessView {

    private func setupLayout() {
        backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        addSubview(trainingTitleLabel)
        addSubview(stopwatchLabel)
        addSubview(exercisesTableView)
        addSubview(finishTrainingButton)

        NSLayoutConstraint.activate([
            trainingTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            trainingTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            trainingTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            stopwatchLabel.topAnchor.constraint(equalTo: trainingTitleLabel.bottomAnchor, constant: 2),
            stopwatchLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            exercisesTableView.topAnchor.constraint(equalTo: stopwatchLabel.bottomAnchor, constant: 5),
            exercisesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            exercisesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            exercisesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            finishTrainingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            finishTrainingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            finishTrainingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            finishTrainingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
