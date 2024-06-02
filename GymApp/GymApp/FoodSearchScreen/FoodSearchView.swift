//
//  FoodSearchView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 30.05.2024.
//

import UIKit

class FoodSearchView: UIView {

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Поиск блюд и продуктов"
        return label
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)
        searchBar.searchTextField.textColor = .white

        return searchBar
    }()

    lazy var gramField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        textField.layer.cornerRadius = 10
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.textColor = .white
        let textFieldTextColor = UIColor(red: 45/255, green: 50/255, blue: 77/255, alpha: 1.0)
        let attributes = [NSAttributedString.Key.foregroundColor: textFieldTextColor]
        let attributedPlaceholder = NSAttributedString(string: "100гр", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.keyboardType = .numberPad

        return textField
    }()

    lazy var productsTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            ProductInfoTableViewCell.self,
            forCellReuseIdentifier: ProductInfoTableViewCell.reuseIdentifier
        )
        tableView.backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)
        tableView.separatorStyle = .none

        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FoodSearchView {
    func setupLayout() {
        backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        addSubview(titleLabel)
        addSubview(searchBar)
        addSubview(productsTableView)
        addSubview(gramField)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -110),

            gramField.topAnchor.constraint(equalTo: searchBar.searchTextField.topAnchor),
            gramField.bottomAnchor.constraint(equalTo: searchBar.searchTextField.bottomAnchor),
            gramField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            gramField.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 1),

            productsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            productsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
