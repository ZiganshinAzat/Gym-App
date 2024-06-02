//
//  TrainingProgramsView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import UIKit

class TrainingProgramsView: UIView {

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ТРЕНИРОВКА"
        label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        label.textColor = .white

        return label
    }()

    lazy var addProgramButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить тренировку", for: .normal)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .heavy)

        let action = UIAction { [weak self] _ in

            if let addNewProgram = self?.addNewProgramButtonAction {
                addNewProgram()
            } else {
                print("Не добавлено событие на кнопку")
            }
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var startImageView: UIImageView = {
        var imageView = RoundImageView(image: UIImage(named: "startImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true

        return imageView
    }()

    lazy var createTrainingLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Создайте свою первую личную тренировку"
        label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true

        return label
    }()

    lazy var trainingProgramsTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            TrainingProgramTableViewCell.self,
            forCellReuseIdentifier: TrainingProgramTableViewCell.reuseIdentifier
        )
        let backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)
        tableView.backgroundColor = backgroundColor

        return tableView
    }()

    var addNewProgramButtonAction: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        addProgramButton.setHorizontalGradientBackground(
            colorLeft: UIColor(red: 0xC7/255, green: 0x56/255, blue: 0xCB/255, alpha: 1.0),
            colorRight: UIColor(red: 0x71/255, green: 0x59/255, blue: 0xF1/255, alpha: 1.0)
        )
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TrainingProgramsView {

    func setupLayout() {
        backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        addSubview(titleLabel)
        addSubview(startImageView)
        addSubview(trainingProgramsTableView)
        addSubview(createTrainingLabel)
        addSubview(addProgramButton)

        NSLayoutConstraint.activate([

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),

            addProgramButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addProgramButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            addProgramButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            addProgramButton.heightAnchor.constraint(equalToConstant: 50),

            startImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 180),
            startImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            startImageView.heightAnchor.constraint(equalToConstant: 180),
            startImageView.widthAnchor.constraint(equalTo: startImageView.heightAnchor),

            createTrainingLabel.topAnchor.constraint(equalTo: startImageView.bottomAnchor, constant: 36),
            createTrainingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            createTrainingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),

            trainingProgramsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            trainingProgramsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            trainingProgramsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trainingProgramsTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
