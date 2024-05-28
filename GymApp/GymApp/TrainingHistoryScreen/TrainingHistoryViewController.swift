//
//  TrainingHistoryViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 23.05.2024.
//

import UIKit
import Combine

class TrainingHistoryViewController: UIViewController {

    private let historyView = TrainingHistoryView()
    private let historyViewModel: TrainingHistoryViewModel
    private var trainingHistoryDataSource: [TrainingHistory] = []
    private var cancellables: Set<AnyCancellable> = []

    init(historyViewModel: TrainingHistoryViewModel) {
        self.historyViewModel = historyViewModel
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Progress", image: .trainingHistory, tag: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = historyView
        historyView.trainingHistoryTableView.dataSource = self
        historyView.trainingHistoryTableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        Task {
            do {
                try await historyViewModel.fetchTrainingHistories()
            } catch {
                print("Error fetching training histories: \(error.localizedDescription)")
            }
        }
    }
}

extension TrainingHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trainingHistoryDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrainingHistoryTableViewCell.reuseIdentifier,
            for: indexPath) as? TrainingHistoryTableViewCell else {
            return UITableViewCell()
        }

        let trainingHistory = trainingHistoryDataSource[indexPath.row]

        if let trainingProgram = historyViewModel.trainingPrograms[trainingHistory.trainingProgramID] {
            cell.configureCell(with: trainingHistory, trainingProgram: trainingProgram)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var backgroundConfig = cell.defaultBackgroundConfiguration()
        backgroundConfig.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        backgroundConfig.cornerRadius = 20
        backgroundConfig.backgroundInsets = .init(top: 5, leading: 20, bottom: 5, trailing: 20)
        backgroundConfig.strokeColor = UIColor(red: 40/255, green: 42/255, blue: 60/255, alpha: 1.0)
        backgroundConfig.strokeWidth = 1.0

        cell.backgroundConfiguration = backgroundConfig
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func setupBindings() {
        historyViewModel.$trainingHistories
            .dropFirst()
            .sink { [weak self] trainingHistories in
                guard let self else { return }

                self.trainingHistoryDataSource = trainingHistories
                DispatchQueue.main.async {
                    self.historyView.trainingHistoryTableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trainingHistory = trainingHistoryDataSource[indexPath.row]
        if let trainingProgram = historyViewModel.trainingPrograms[trainingHistory.trainingProgramID] {
            showTrainingHistoryDetailScreen(trainingHistory: trainingHistory, trainingProgram: trainingProgram)
        }
    }

    func showTrainingHistoryDetailScreen(trainingHistory: TrainingHistory, trainingProgram: TrainingProgram) {
        let trainingHistoryDetailVM = TrainingHistoryDetailViewModel()
        let trainingHistoryDetailVC = TrainingHistoryDetailVC(historyDetailViewModel: trainingHistoryDetailVM, trainingProgram: trainingProgram, trainingHistory: trainingHistory)
        self.navigationController?.pushViewController(trainingHistoryDetailVC, animated: true)
    }
}
