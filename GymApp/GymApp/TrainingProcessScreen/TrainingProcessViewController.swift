//
//  TrainingProcessViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.04.2024.
//

import UIKit
import Combine

class TrainingProcessViewController: UIViewController {

    private let trainingProcessView = TrainingProcessView()
    private let trainingProcessViewModel: TrainingProcessViewModel
    private var trainingProgram: TrainingProgram
    private var cancellables: Set<AnyCancellable> = []
    private var exerciseInputs: [String: [ExerciseSetInput]] = [:]

    init(viewModel: TrainingProcessViewModel, trainingProgram: TrainingProgram) {
        self.trainingProcessViewModel = viewModel
        self.trainingProgram = trainingProgram

        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Training", image: .trainingProgramsIcon, tag: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = trainingProcessView
        trainingProcessView.exercisesTableView.dataSource = self
        trainingProcessView.exercisesTableView.delegate = self
        trainingProcessView.finishTrainingButtonTapped = finishTrainingButtonAction
        trainingProcessView.resetTimer = resetTimer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        trainingProcessView.trainingTitleLabel.text = trainingProgram.name
    }

    private func setupBindings() {
        trainingProcessViewModel.$timeElapsed
            .sink { [weak self] time in
                self?.updateTimerLabel(with: time)
            }
            .store(in: &cancellables)
    }

    private func updateTimerLabel(with time: TimeInterval) {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        self.trainingProcessView.stopwatchLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

extension TrainingProcessViewController: UITableViewDataSource, UITableViewDelegate {
    func resetTimer() {
        trainingProcessViewModel.resetTimer()
    }

    func finishTrainingButtonAction() {
        let alertController = UIAlertController(
            title: "Закончить тренировку",
            message: "Вы уверены, что хотите закончить эту тренировку?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let finishAction = UIAlertAction(title: "Закончить", style: .default) { [weak self] _ in
            self?.completeTraining()
        }
        alertController.addAction(finishAction)

        present(alertController, animated: true, completion: nil)
    }

    private func completeTraining() {
        Task {
            let id = UUID().uuidString
            let userId = await trainingProcessViewModel.getAuthenticatedUserId()!
            let date = Date()
            let trainingProgramId = self.trainingProgram.id
            let exercisesHistory = getExerciseHistoryModels()
            let trainingHistory = TrainingHistory(
                id: id,
                userID: userId,
                date: date,
                trainingProgramID: trainingProgramId,
                exerciseHistories: exercisesHistory
            )
            await trainingProcessViewModel.saveTrainingHistory(trainingHistory: trainingHistory)

            if let tabBarController = self.tabBarController {
                if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                    let viewModel = TrainingProgramsViewModel()
                    let trainingProgramsVC = TrainingProgramsViewController(viewModel: viewModel)
                    navController.setViewControllers([trainingProgramsVC], animated: true)
                    tabBarController.selectedIndex = 0
                }
            }
        }
    }

    private func getExerciseHistoryModels() -> [ExerciseHistory] {
        var result: [ExerciseHistory] = []

        for exercise in trainingProgram.exercises {
            let exerciseID = exercise.id
            guard let inputs = exerciseInputs[exerciseID] else { continue }

            var sets: [ExerciseSet] = []
            for (index, input) in inputs.enumerated() {
                if !input.weight.isEmpty, let weight = Int(input.weight), let repetitions = Int(input.repetitions) {
                    let set = ExerciseSet(weight: weight, repetitions: repetitions, index: index)
                    sets.append(set)
                }
            }

            let exerciseHistory = ExerciseHistory(id: UUID().uuidString, exerciseID: exerciseID, sets: sets)
            result.append(exerciseHistory)
        }

        return result
    }

    func finishButtonTapped() {
        trainingProcessViewModel.resetTimer()
        UIView.transition(with: trainingProcessView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.trainingProcessView.startButton.isHidden = false
            self.trainingProcessView.breakLabel.isHidden = false
            self.trainingProcessView.exercisesTableView.isHidden = true
        }, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trainingProgram.exercises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrainingProcessTableViewCell.reuseIdentifier,
            for: indexPath) as? TrainingProcessTableViewCell else {
            return UITableViewCell()
        }

        let exercise = trainingProgram.exercises[indexPath.row]
        cell.selectionStyle = .none
        cell.finishButtonTapped = self.finishButtonTapped
        cell.configureCell(with: trainingProgram.exercises[indexPath.row])
        cell.updateSetInput = { [weak self] setIndex, input in
            self?.exerciseInputs[
                exercise.id,
                default: Array(
                    repeating: ExerciseSetInput(weight: "", repetitions: ""),
                    count: 3
                )
            ][setIndex] = input
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        backgroundConfig.cornerRadius = 20
        backgroundConfig.backgroundInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        backgroundConfig.strokeColor = UIColor(red: 40/255, green: 42/255, blue: 60/255, alpha: 1.0)
        backgroundConfig.strokeWidth = 1.0

        cell.backgroundConfiguration = backgroundConfig
    }

    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 120
    //    }
}
