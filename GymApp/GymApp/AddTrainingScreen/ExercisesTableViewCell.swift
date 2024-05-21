//
//  ExercisesTableViewCell.swift
//  GymApp
//
//  Created by Азат Зиганшин on 12.03.2024.
//

import UIKit

class ExercisesTableViewCell: UITableViewCell {

    var numberCircleView: StringCircleView = {
        let stringCircleView = StringCircleView()
        stringCircleView.translatesAutoresizingMaskIntoConstraints = false

        return stringCircleView
    }()

    lazy var exerciseTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white

        return label
    }()

    lazy var exerciseIconImageView: UIImageView = {
        var imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray

        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exerciseIconTapped))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }()

    var exerciseImageViewTapped: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExercisesTableViewCell {

    @objc func exerciseIconTapped() {
        if let exerciseImageViewTapped {
            guard let number = numberCircleView.numberLabel.text else { return }
            guard let index = Int(number) else { return }
            exerciseImageViewTapped(index - 1)
        } else {
            print("No action for imageView")
        }
    }

    func configureCell(with exercise: Exercise) {
        self.exerciseTitleLabel.text = exercise.name
        self.exerciseIconImageView.image = UIImage(named: exercise.image)
        self.numberCircleView.setupLabel(text: "\(exercise.index + 1)")

        if UIImage(named: exercise.image) != nil {
            exerciseIconImageView.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        } else {
            exerciseIconImageView.backgroundColor = .systemGray
        }
    }

    func setupLayout() {
        contentView.addSubview(numberCircleView)
        contentView.addSubview(exerciseTitleLabel)
        contentView.addSubview(exerciseIconImageView)

        NSLayoutConstraint.activate([
            numberCircleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            numberCircleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberCircleView.widthAnchor.constraint(equalToConstant: 50),
            numberCircleView.heightAnchor.constraint(equalTo: numberCircleView.widthAnchor),

            exerciseTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            exerciseTitleLabel.centerYAnchor.constraint(equalTo: numberCircleView.centerYAnchor),

            exerciseIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            exerciseIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            exerciseIconImageView.heightAnchor.constraint(equalToConstant: 70),
            exerciseIconImageView.widthAnchor.constraint(equalTo: exerciseIconImageView.heightAnchor)
        ])
    }
}
