//
//  AddTrainingViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import UIKit

class AddTrainingViewController: UIViewController {

    private let addTrainingView: AddTrainingView = .init()
    private var viewModel: AddTrainingViewModel
    private var exercisesTableViewDataSource = ExercisesTableViewDataSource()

    init(viewModel: AddTrainingViewModel) {
        
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        view = addTrainingView
        addTrainingView.addButtonTapped = self.addButtonTapped
        addTrainingView.exercisesTableView.dataSource = exercisesTableViewDataSource
        addTrainingView.deleteCell = deleteCellFromExercisesTableView
        addTrainingView.editButtonTapped = editButtonTapped
        addTrainingView.backButtonTapped = backButtonTapped
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension AddTrainingViewController {

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

    func deleteCellFromExercisesTableView(indexPath: IndexPath) {

        exercisesTableViewDataSource.dataSource.remove(at: indexPath.row)
    }

    func appendExercise(_ exercise: String) {

        exercisesTableViewDataSource.dataSource.append(exercise)
        addTrainingView.exercisesTableView.reloadData()
    }

    func editButtonTapped() {

        addTrainingView.exercisesTableView.isEditing.toggle()
    }

    func backButtonTapped() {

        navigationController?.popViewController(animated: true)
    }
}
