//
//  AddTrainingViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import UIKit

class AddTrainingViewController: UIViewController {

    private let addTrainingView = AddTrainingView()
    private var viewModel: AddTrainingViewModel
    private var exercisesDataSource: [Exercise] = []
    private var trainingIconName = ""

    init(viewModel: AddTrainingViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = addTrainingView
        addTrainingView.viewModel = viewModel
        addTrainingView.addButtonTapped = self.addButtonTapped
        addTrainingView.exercisesTableView.dataSource = self
        addTrainingView.exercisesTableView.delegate = self
        addTrainingView.trainingImageViewTapped = trainingIconTapped
        addTrainingView.saveButtonAction = saveButtonAction
        viewModel.onSavingSuccess = onSavingSuccess
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
    }
}

extension AddTrainingViewController: UITableViewDataSource, UITableViewDelegate {

    func saveButtonAction() {
        Task {
            guard let userId = await viewModel.getAuthenticatedUserId() else {
                print("Пользователь не зарегистрирован"); return
            }
            guard !exercisesDataSource.isEmpty else {
                showExercisesEmptyAlert(); return
            }
            let id = UUID().uuidString
            let trainingName = addTrainingView.trainingTitleTextField.text!
            viewModel.saveTrainingProgram(trainingProgram: TrainingProgram(id: id, name: trainingName, image: trainingIconName, userID: userId, exercises: exercisesDataSource))
        }
    }

    func onSavingSuccess() {
        DispatchQueue.main.async {
            self.showTrainingProgramAddedAlert()
        }
    }

    func trainingIconTapped() {
        let dataSource = IconsManager.shared.getTrainingProgramsIcons()
        let iconsViewController = IconsViewController(iconsDataSource: dataSource, selectLabelText: "Выберите иконку тренировки")
        iconsViewController.iconSelectedAction = { [weak self] imageName in
            self?.addTrainingView.trainingIconImageView.image = UIImage(named: imageName)
            self?.trainingIconName = imageName
        }
        present(iconsViewController, animated: true)
    }

    func exerciseIconTapped(index: Int) {
        let dataSource = IconsManager.shared.getMuscleGroupsIcons()
        let iconsViewController = IconsViewController(iconsDataSource: dataSource, selectLabelText: "Выберите иконку упражнения")
        iconsViewController.iconSelectedAction = { [weak self] image in
            self?.exercisesDataSource[index].image = image
            self?.addTrainingView.exercisesTableView.reloadData()
        }
        present(iconsViewController, animated: true)
    }

    func addButtonTapped() {
        let alertController = UIAlertController(title: "Добавить упражнение", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }

        let addAction = UIAlertAction(title: "Добавить", style: .default) {[weak self] _ in

            if let text = alertController.textFields?.first?.text, !text.isEmpty {

                self?.appendExercise(text)
            }
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func appendExercise(_ exerciseName: String) {
        let index = exercisesDataSource.count
        let exercise = Exercise(id: UUID().uuidString, name: exerciseName, image: "", index: index)
        exercisesDataSource.append(exercise)
        addTrainingView.exercisesTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercisesDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExercisesTableViewCell.reuseIdentifier,
            for: indexPath) as? ExercisesTableViewCell else {
            return UITableViewCell()
        }
        exercisesDataSource[indexPath.row].index = indexPath.row
        cell.configureCell(with: exercisesDataSource[indexPath.row])
        cell.selectionStyle = .none
        cell.exerciseImageViewTapped = exerciseIconTapped

        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
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
        return 120
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completion) in

            UIView.transition(
                with: tableView,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: { [weak self] in
                    self?.exercisesDataSource.remove(at: indexPath.row)
                    tableView.reloadData()
                })

            completion(true)
        }

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }

    func showExercisesEmptyAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Добавьте хотя бы одно упражнение для тренировки", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showTrainingProgramAddedAlert() {
        let alert = UIAlertController(title: "Готово", message: "Тренировка успешно добавлена", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
