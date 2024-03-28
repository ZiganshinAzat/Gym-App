//
//  ViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import UIKit

class TrainingProgramsViewController: UIViewController {

    private let trainingProgramsView: TrainingProgramsView = .init()
    private var viewModel: TrainingProgramsViewModel

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) 

    }
}

extension TrainingProgramsViewController {

    func addNewProgram() {

        let addTrainingViewController = AddTrainingViewController(viewModel: AddTrainingViewModel())

        self.navigationController?.pushViewController(addTrainingViewController, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
    }
}
