//
//  CategoryAuctionsViewController.swift
//  Bidly
//
//  Created by Baytik  on 27/4/25.
//

import UIKit

class CategoryAuctionsViewController: UIViewController {

    private let category: Category
    private var items: [AuctionItem] = []
    
    private let tableView = UITableView()

    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
        title = category.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
//        loadItems()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

//    private func loadItems() {
//        // Пока фейковые аукционы
//        items = [
//            AuctionItem(imageName: "electronic", title: "iPhone 15 Pro", category: .electronics, startPrice: 1000, lastBid: 1200, endDate: Date(), description: "Топовый телефон", sellerName: "Иван", imageNames: ["electronic"]),
//            AuctionItem(imageName: "electronic", title: "MacBook Air", category: .electronics, startPrice: 1500, lastBid: 1800, endDate: Date(), description: "Лёгкий и мощный ноутбук", sellerName: "Мария", imageNames: ["electronic"])
//        ].filter { $0.category == category }
//        
//        tableView.reloadData()
//    }
}

extension CategoryAuctionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.title
        return cell
    }
}
