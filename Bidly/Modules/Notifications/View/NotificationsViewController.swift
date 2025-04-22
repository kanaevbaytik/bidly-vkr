//
//  NotificationsViewController.swift
//  Bidly
//
//  Created by Baytik  on 9/3/25.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var sections: [NotificationSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Уведомления"
        
        setupTableView()
        loadMockData() // для теста пока
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
    }
    
    private func loadMockData() {
        let calendar = Calendar.current
        let now = Date()
        
        let today1 = NotificationItem(
            type: .bidPlaced,
            title: "Сделал ставку на ваш лот 5500 KGS",
            subtitle: "Асан Асанов сделал ставку на ваш лот “MacBook Air 13.6 inch” в размере 5500 KGS",
            date: now,
            avatarImage: UIImage(named: "user1"),
            thumbnailImage: nil,
            amount: "5500 KGS",
            isNew: true
        )
        
        let today2 = NotificationItem(
            type: .bidOutbid,
            title: "Ваша ставка была перебита",
            subtitle: nil,
            date: now,
            avatarImage: UIImage(named: "user2"),
            thumbnailImage: nil,
            amount: nil,
            isNew: true
        )
        
        let yesterday1 = NotificationItem(
            type: .goalReached,
            title: "You have raised $20,000 of",
            subtitle: "$50,000 goal",
            date: calendar.date(byAdding: .day, value: -1, to: now)!,
            avatarImage: nil,
            thumbnailImage: UIImage(named: "goal"),
            amount: "$20,000",
            isNew: false
        )
        
        let yesterday2 = NotificationItem(
            type: .donation,
            title: "Victor Hansen has donated $500",
            subtitle: "We are praying for you Rosalyn! Keep fighting the good fight!",
            date: calendar.date(byAdding: .day, value: -1, to: now)!,
            avatarImage: UIImage(named: "user3"),
            thumbnailImage: nil,
            amount: "$500",
            isNew: false
        )
        
        let lastMonth = NotificationItem(
            type: .message,
            title: "You have received a new message from Jessica",
            subtitle: nil,
            date: calendar.date(byAdding: .day, value: -10, to: now)!,
            avatarImage: nil,
            thumbnailImage: nil,
            amount: nil,
            isNew: true
        )
        
        let allItems = [today1, today2, yesterday1, yesterday2, lastMonth]
        self.sections = groupNotificationsByDate(items: allItems)
        tableView.reloadData()
    }
    
    private func groupNotificationsByDate(items: [NotificationItem]) -> [NotificationSection] {
        let calendar = Calendar.current
        var today: [NotificationItem] = []
        var yesterday: [NotificationItem] = []
        var thisMonth: [NotificationItem] = []
        
        for item in items {
            if calendar.isDateInToday(item.date) {
                today.append(item)
            } else if calendar.isDateInYesterday(item.date) {
                yesterday.append(item)
            } else {
                thisMonth.append(item)
            }
        }
        
        var result: [NotificationSection] = []
        if !today.isEmpty {
            result.append(NotificationSection(title: "Сегодня", items: today))
        }
        if !yesterday.isEmpty {
            result.append(NotificationSection(title: "Вчера", items: yesterday))
        }
        if !thisMonth.isEmpty {
            result.append(NotificationSection(title: "За этот месяц", items: thisMonth))
        }
        return result
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}
