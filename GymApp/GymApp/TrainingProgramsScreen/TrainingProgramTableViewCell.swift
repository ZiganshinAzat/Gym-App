//
//  TrainingProgramTableViewCell.swift
//  GymApp
//
//  Created by Азат Зиганшин on 20.05.2024.
//

import UIKit

class TrainingProgramTableViewCell: UITableViewCell {

    lazy var trainingProgramNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)

        return label
    }()

    lazy var trainingProgramImageView: UIImageView = {
        var imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray

        return imageView
    }()

    lazy var exercisesCountLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrainingProgramTableViewCell {
    func setupLayout() {
        addSubview(trainingProgramNameLabel)
        addSubview(trainingProgramImageView)
        addSubview(exercisesCountLabel)

        NSLayoutConstraint.activate([
            trainingProgramNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            trainingProgramNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26),

            exercisesCountLabel.leadingAnchor.constraint(equalTo: trainingProgramNameLabel.leadingAnchor),
            exercisesCountLabel.topAnchor.constraint(equalTo: trainingProgramNameLabel.bottomAnchor, constant: 10),

            trainingProgramImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            trainingProgramImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            trainingProgramImageView.heightAnchor.constraint(equalToConstant: 80),
            trainingProgramImageView.widthAnchor.constraint(equalTo: trainingProgramImageView.heightAnchor)
        ])
    }

    func configureCell(with trainingProgram: TrainingProgram) {
        trainingProgramNameLabel.text = trainingProgram.name
        trainingProgramImageView.image = UIImage(named: trainingProgram.image)
        exercisesCountLabel.text = "Упражнений: \(trainingProgram.exercises.count)"
    }
}
