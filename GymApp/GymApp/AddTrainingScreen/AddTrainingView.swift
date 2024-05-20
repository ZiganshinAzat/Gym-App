//
//  AddTrainingView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import UIKit

class AddTrainingView: UIView {

    lazy var trainingTitleTextField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 40/255, green: 42/255, blue: 60/255, alpha: 1.0).cgColor
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.textColor = .white
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 45/255, green: 50/255, blue: 77/255, alpha: 1.0)]
        let attributedPlaceholder = NSAttributedString(string: "Название тренировки", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder

        return textField
    }()

    lazy var trainingIconImageView: UIImageView = {
        var imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray

        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(trainingIconTapped))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }()

    lazy var addExerciseButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addButtonIcon"), for: .normal)

        let action = UIAction { [weak self] _ in
            guard let addButtonTapped = self?.addButtonTapped else { return }
            addButtonTapped()
        }

        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var editButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "editButtonIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        let action = UIAction { [weak self] _ in
            guard let editButtonTapped = self?.editButtonTapped else { return }
            editButtonTapped()
        }

        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var backButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "backButtonIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        let action = UIAction { [weak self] _ in
            guard let backButtonTapped = self?.backButtonTapped else { return }
            backButtonTapped()
        }

        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var exercisesTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExercisesTableViewCell.self, forCellReuseIdentifier: ExercisesTableViewCell.reuseIdentifier)
        tableView.backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true

        return tableView
    }()

    var addButtonTapped: (() -> Void)?
    var editButtonTapped: (() -> Void)?
    var backButtonTapped: (() -> Void)?
    var trainingImageViewTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddTrainingView: UITableViewDelegate {

    func setupLayout() {
        backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        addSubview(trainingTitleTextField)
        addSubview(trainingIconImageView)
        addSubview(exercisesTableView)
        addSubview(addExerciseButton)
        addSubview(editButton)
        addSubview(backButton)

        NSLayoutConstraint.activate([

            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),

            editButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            editButton.heightAnchor.constraint(equalToConstant: 25),
            editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor),

            trainingIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trainingIconImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            trainingIconImageView.heightAnchor.constraint(equalToConstant: 80),
            trainingIconImageView.widthAnchor.constraint(equalTo: trainingIconImageView.heightAnchor),

            trainingTitleTextField.leadingAnchor.constraint(equalTo: trainingIconImageView.trailingAnchor, constant: 10),
            trainingTitleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            trainingTitleTextField.centerYAnchor.constraint(equalTo: trainingIconImageView.centerYAnchor),
            trainingTitleTextField.heightAnchor.constraint(equalToConstant: 40),

            exercisesTableView.topAnchor.constraint(equalTo: trainingIconImageView.bottomAnchor, constant: 10),
            exercisesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            exercisesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            exercisesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            addExerciseButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addExerciseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            addExerciseButton.heightAnchor.constraint(equalToConstant: 60),
            addExerciseButton.widthAnchor.constraint(equalTo: addExerciseButton.heightAnchor)

        ])
    }

    @objc func trainingIconTapped() {
        if let trainingImageViewTapped {
            trainingImageViewTapped()
        }
        else {
            print("No action for imageView")
        }
    }
}
