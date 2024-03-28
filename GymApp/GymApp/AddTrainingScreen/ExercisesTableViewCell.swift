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


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExercisesTableViewCell {

    func configureCell(title: String, number: String) {
        
        self.exerciseTitleLabel.text = title
        self.numberCircleView.setupLabel(text: number)
    }

    func setupLayout() {

        addSubview(numberCircleView)
        addSubview(exerciseTitleLabel)

        NSLayoutConstraint.activate([
            numberCircleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            numberCircleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberCircleView.widthAnchor.constraint(equalToConstant: 50),
            numberCircleView.heightAnchor.constraint(equalTo: numberCircleView.widthAnchor),

            exerciseTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            exerciseTitleLabel.centerYAnchor.constraint(equalTo: numberCircleView.centerYAnchor)
        ])
    }
}
