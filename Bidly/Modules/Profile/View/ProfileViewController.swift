//
//  ProfileViewController.swift
//  Bidly
//
//  Created by Baytik  on 9/3/25.
//

import UIKit

class ProfileViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let profileHeaderView: UIView = {
        let container = UIView()

        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true

        let nameLabel = UILabel()
        nameLabel.text = "Имя пользователя"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        container.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])

        container.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120)
        return container
    }()

    private let items: [(title: String, icon: String, iconColor: UIColor)] = [
        ("Мои лоты", "cube.box.fill", .systemBlue),
        ("Адрес", "map.fill", .systemGreen),
        ("Избранные лоты", "heart.fill", .systemPink),
        ("Настройки", "gearshape.fill", .systemGray),
        ("Поддержка", "questionmark.circle.fill", .systemOrange)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Профиль"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = profileHeaderView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.image = UIImage(systemName: item.icon)
        config.imageProperties.tintColor = item.iconColor
        cell.contentConfiguration = config

        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc: UIViewController

        switch indexPath.row {
        case 0:
            vc = MyLotsViewController()
        case 1:
            vc = AdressViewController()
        case 2:
            vc = FavoritesViewController()
        case 3:
            vc = SettingsViewController()
        case 4:
            vc = SupportViewController()
        default:
            return
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
