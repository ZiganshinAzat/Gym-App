import UIKit
import Combine

class FoodSearchViewController: UIViewController {

    private let foodSearchView = FoodSearchView()
    private let foodSearchViewModel: FoodSearchViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var productsDataSource: [Product] = []
    private let searchTextSubject = PassthroughSubject<String, Never>()

    init(foodSearchViewModel: FoodSearchViewModel) {
        self.foodSearchViewModel = foodSearchViewModel
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Food", image: .foodCalc, tag: 2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = foodSearchView
        foodSearchView.searchBar.delegate = self
        foodSearchView.productsTableView.dataSource = self
        foodSearchView.productsTableView.delegate = self
        foodSearchView.gramField.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }
}

extension FoodSearchViewController {

    func setupBindings() {
        foodSearchViewModel.$products
            .sink { [weak self] products in
                guard let self else { return }

                self.productsDataSource = products

                DispatchQueue.main.async {
                    self.foodSearchView.productsTableView.reloadData()
                }
            }
            .store(in: &cancellables)

        searchTextSubject
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                Task {
                    await self?.foodSearchViewModel.getProducts(productName: searchText)
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: foodSearchView.gramField)
            .compactMap { $0.object as? UITextField }
            .compactMap { $0.text }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.handleGramFieldChange(text)
            }
            .store(in: &cancellables)
    }

    private func handleGramFieldChange(_ text: String) {
        foodSearchView.productsTableView.reloadData()
    }
}

extension FoodSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.send(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension FoodSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductInfoTableViewCell.reuseIdentifier,
            for: indexPath) as? ProductInfoTableViewCell else {
            return UITableViewCell()
        }

        let product = productsDataSource[indexPath.row]

        let grams = Int(foodSearchView.gramField.text ?? "100") ?? 100

        cell.configureCell(with: product, grams: grams)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var backgroundConfig = cell.defaultBackgroundConfiguration()
        backgroundConfig.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        backgroundConfig.cornerRadius = 20
        backgroundConfig.backgroundInsets = .init(top: 5, leading: 10, bottom: 5, trailing: 10)
        backgroundConfig.strokeColor = UIColor(red: 40/255, green: 42/255, blue: 60/255, alpha: 1.0)
        backgroundConfig.strokeWidth = 1.0

        cell.backgroundConfiguration = backgroundConfig

        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.2

        let shadowPath = UIBezierPath(
            roundedRect: cell.bounds.insetBy(dx: 10, dy: 5),
            cornerRadius: backgroundConfig.cornerRadius
        )
        cell.layer.shadowPath = shadowPath.cgPath
    }
}

extension FoodSearchViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
