//
//  TrainingHistoryDetailVC.swift
//  GymApp
//
//  Created by Азат Зиганшин on 28.05.2024.
//

import UIKit

class TrainingHistoryDetailVC: UIViewController {

    private let historyDetailView = TrainingHistoryDetailView()
    private let historyDetailViewModel: TrainingHistoryDetailViewModel
    private let trainingProgram: TrainingProgram
    private let trainingHistory: TrainingHistory

    init(historyDetailViewModel: TrainingHistoryDetailViewModel, trainingProgram: TrainingProgram, trainingHistory: TrainingHistory) {
        self.historyDetailViewModel = historyDetailViewModel
        self.trainingProgram = trainingProgram
        self.trainingHistory = trainingHistory
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Progress", image: .trainingHistory, tag: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = historyDetailView
        historyDetailView.configure(with: trainingHistory, trainingProgram: trainingProgram)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
