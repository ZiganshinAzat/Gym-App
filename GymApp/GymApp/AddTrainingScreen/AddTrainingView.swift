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

        return imageView
    }()

    lazy var addExerciseButton: UIButton = {

        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addButtonIcon"), for: .normal)

        let action = UIAction { [weak self] _ in
            if let addButtonAction = self?.addButtonTapped {
                addButtonAction()
            }
        }

        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var editButton: UIButton = {

        var button = UIButton()
        button.setImage(UIImage(named: "editButtonIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        let action = UIAction { [weak self] _ in
            if let editButtonAction = self?.editButtonTapped {
                editButtonAction()
            }
        }

        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var backButton: UIButton = {

        var button = UIButton()
        button.setImage(UIImage(named: "backButtonIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        let action = UIAction { [weak self] _ in
            if let backButtonAction = self?.backButtonTapped {
                backButtonAction()
            }
        }

        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var exercisesTableView: UITableView = {

        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(ExercisesTableViewCell.self, forCellReuseIdentifier: ExercisesTableViewCell.reuseIdentifier)
        tableView.backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        return tableView
    }()

    var addButtonTapped: (() -> Void)?
    var editButtonTapped: (() -> Void)?
    var backButtonTapped: (() -> Void)?
    var deleteCell: ((_ indexPath: IndexPath) -> Void)?

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
            addExerciseButton.heightAnchor.constraint(equalToConstant: 50),
            addExerciseButton.widthAnchor.constraint(equalTo: addExerciseButton.heightAnchor)

        ])
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var backgroundConfig = cell.defaultBackgroundConfiguration()
        backgroundConfig.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        backgroundConfig.cornerRadius = 20
        backgroundConfig.backgroundInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        backgroundConfig.strokeColor = UIColor(red: 40/255, green: 42/255, blue: 60/255, alpha: 1.0)
        backgroundConfig.strokeWidth = 1.0

        cell.backgroundConfiguration = backgroundConfig
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completion) in

            guard let deleteCell = self.deleteCell else { return }

            UIView.transition(
                with: tableView,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: {
                    deleteCell(indexPath)
                    tableView.reloadData()
                })

            completion(true)
        }


        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }

}
