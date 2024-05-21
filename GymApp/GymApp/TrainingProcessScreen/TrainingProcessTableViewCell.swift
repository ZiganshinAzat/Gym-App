//
//  TrainingProcessTableViewCell.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.04.2024.
//

import UIKit

class TrainingProcessTableViewCell: UITableViewCell {

    lazy var exerciseIconImageView: UIImageView = {
        var imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray

        return imageView
    }()

    lazy var exerciseTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Жим лежа"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white

        return label
    }()

    lazy var setsStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        //stackView.distribution = .fillEqually

        return stackView
    }()

    lazy var firstSetView: SetView = {
        var setView = SetView()
        setView.setNumber("1")
        setView.finishButtonTapped = { [weak self] in
            self?.finishButtonTapped?()
        }
        return setView
    }()

    lazy var secondSetView: SetView = {
        var setView = SetView()
        setView.setNumber("2")
        setView.finishButtonTapped = { [weak self] in
            self?.finishButtonTapped?()
        }
        return setView
    }()

    lazy var thirdSetView: SetView = {
        var setView = SetView()
        setView.setNumber("3")
        setView.finishButtonTapped = { [weak self] in
            self?.finishButtonTapped?()
        }
        return setView
    }()

    var finishButtonTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TrainingProcessTableViewCell {

    private func setupLayout() {

        setsStackView.addArrangedSubview(firstSetView)
        setsStackView.addArrangedSubview(secondSetView)
        setsStackView.addArrangedSubview(thirdSetView)

        contentView.addSubview(exerciseIconImageView)
        contentView.addSubview(exerciseTitleLabel)
        contentView.addSubview(setsStackView)

        for view in setsStackView.arrangedSubviews {
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 50)
            ])
        }

        NSLayoutConstraint.activate([
            exerciseIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            exerciseIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            exerciseIconImageView.heightAnchor.constraint(equalToConstant: 60),
            exerciseIconImageView.widthAnchor.constraint(equalTo: exerciseIconImageView.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            exerciseTitleLabel.centerYAnchor.constraint(equalTo: exerciseIconImageView.centerYAnchor),
            exerciseTitleLabel.leadingAnchor.constraint(equalTo: exerciseIconImageView.trailingAnchor, constant: 20),
            exerciseTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            setsStackView.topAnchor.constraint(equalTo: exerciseIconImageView.bottomAnchor, constant: 15),
            setsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            setsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])

        let bottomConstraint = setsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        bottomConstraint.priority = UILayoutPriority(999)
        bottomConstraint.isActive = true

        for view in setsStackView.arrangedSubviews {
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }

    func configureCell(with exercise: Exercise) {
        self.exerciseTitleLabel.text = exercise.name
        self.exerciseIconImageView.image = UIImage(named: exercise.image)
    }
}
