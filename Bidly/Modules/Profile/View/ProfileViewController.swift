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

    private let sections: [[(title: String, icon: String, iconColor: UIColor)]] = [
        [
            ("Мои лоты", "cube.box.fill", .systemBlue),
            ("Адрес", "map.fill", .systemGreen),
            ("Избранные лоты", "heart.fill", .systemPink),
            ("Настройки", "gearshape.fill", .systemGray),
            ("Поддержка", "questionmark.circle.fill", .systemOrange)
        ],
        [
            ("Выйти из аккаунта", "arrow.backward.square.fill", .systemRed)
        ]
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

    private func handleLogout() {
        let alert = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { _ in
            AuthService.shared.logout()

            // Переход к экрану авторизации
            let loginVC = AuthViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }))
        present(alert, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.image = UIImage(systemName: item.icon)
        config.imageProperties.tintColor = item.iconColor
        config.textProperties.color = item.iconColor == .systemRed ? .systemRed : .label
        cell.contentConfiguration = config

        cell.accessoryType = item.title == "Выйти из аккаунта" ? .none : .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = sections[indexPath.section][indexPath.row]

        if item.title == "Выйти из аккаунта" {
            handleLogout()
            return
        }

        let vc: UIViewController

        switch item.title {
        case "Мои лоты":
            vc = MyLotsViewController()
        case "Адрес":
            vc = AdressViewController()
        case "Избранные лоты":
            vc = FavoritesViewController()
        case "Настройки":
            vc = SettingsViewController()
        case "Поддержка":
            vc = SupportViewController()
        default:
            return
        }

        navigationController?.pushViewController(vc, animated: true)
    }
}
