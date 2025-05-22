//
//  MyLotsViewController.swift
//  Bidly
//
//  Created by Baytik  on 19/4/25.
//

import UIKit

class MyLotsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private var lots: [LotStorageModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои лоты"
        view.backgroundColor = .systemBackground

//        lots = LotStorageService.fetchAll()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lots.isEmpty {
            tableView.setEmptyMessage("У вас пока нет лотов")
        } else {
            tableView.restore()
        }
        return lots.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lot = lots[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = lot.title
        config.secondaryText = "Категория: \(lot.category)\nДо \(lot.endDate)"
        config.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = config
        return cell
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

