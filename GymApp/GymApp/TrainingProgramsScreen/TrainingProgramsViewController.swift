//
//  ViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import UIKit

class TrainingProgramsViewController: UIViewController {

    private let trainingProgramsView = TrainingProgramsView()
    private var viewModel: TrainingProgramsViewModel
    private var trainingProgramsDataSource: [TrainingProgram] = []

    init(viewModel: TrainingProgramsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = trainingProgramsView
        trainingProgramsView.addNewProgramButtonAction = addNewProgram
        trainingProgramsView.trainingProgramsTableView.delegate = self
        trainingProgramsView.trainingProgramsTableView.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        Task {
            self.trainingProgramsDataSource = try await viewModel.fetchTrainingPrograms()
            DispatchQueue.main.async {
                self.trainingProgramsView.trainingProgramsTableView.reloadData()
                self.manageViews()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) 

    }
}

extension TrainingProgramsViewController: UITableViewDelegate, UITableViewDataSource {
    func manageViews() {
        if trainingProgramsDataSource.isEmpty {
            trainingProgramsView.createTrainingLabel.isHidden = false
            trainingProgramsView.startImageView.isHidden = false
            trainingProgramsView.trainingProgramsTableView.isHidden = true
        } else {
            trainingProgramsView.createTrainingLabel.isHidden = true
            trainingProgramsView.startImageView.isHidden = true
            trainingProgramsView.trainingProgramsTableView.isHidden = false
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trainingProgramsDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrainingProgramTableViewCell.reuseIdentifier,
            for: indexPath) as? TrainingProgramTableViewCell else {
            return UITableViewCell()
        }

        let trainingProgram = trainingProgramsDataSource[indexPath.row]
        cell.configureCell(with: trainingProgram)

        return cell
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showConfirmationAlert(indexPath: indexPath)
    }

    func showConfirmationAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Начать тренировку", message: "Вы уверены, что хотите начать тренировку?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Начать", style: .default, handler: { _ in
            if let tabBarController = self.tabBarController {
                if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                    let training = self.trainingProgramsDataSource[indexPath.row]
                    let viewModel = TrainingProcessViewModel()
                    let trainingProcessVC = TrainingProcessViewController(viewModel: viewModel, trainingProgram: training)
                    navController.setViewControllers([trainingProcessVC], animated: true)
                    tabBarController.selectedIndex = 0
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func addNewProgram() {
        Task {
            guard await viewModel.isUserAuthenticated() else {
                showAuthorizationRequiredAlert()
                return
            }

            let addTrainingViewController = AddTrainingViewController(viewModel: AddTrainingViewModel())

            self.navigationController?.pushViewController(addTrainingViewController, animated: true)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        }
    }

    func showAuthorizationRequiredAlert() {
        let alert = UIAlertController(title: "Требуется авторизация", message: "Для доступа к этой функции необходимо войти в систему. Пожалуйста, авторизуйтесь.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

        }))
        present(alert, animated: true, completion: nil)
    }
}
