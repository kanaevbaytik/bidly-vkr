//
//  ChatListViewController.swift
//  Bidly
//
//  Created by Baytik  on 21/6/25.
//

import UIKit

struct ChatPreview {
    let username: String
    let lastMessage: String
    let timestamp: Date
    let avatarImage:UIImage?
}

struct ChatSection {
    let title: String
    var chats: [ChatPreview]
}

class ChatListViewController: UIViewController {

    private var chatSections: [ChatSection] = [
        ChatSection(title: "Сегодня", chats: [
            ChatPreview(username: "Иван", lastMessage: "Привет!", timestamp: Date(), avatarImage: UIImage(systemName: "person.circle.fill"))
        ]),
        ChatSection(title: "Ранее", chats: [
            ChatPreview(username: "Анна", lastMessage: "До встречи!", timestamp: Date().addingTimeInterval(-86400), avatarImage: UIImage(systemName: "person.circle.fill"))
        ])
    ]


    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "ChatCell")
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Чаты"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.register(ChatListCell.self, forCellReuseIdentifier: "ChatListCell")
        tableView.sectionHeaderTopPadding = 8

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        chatSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatSections[section].chats.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        chatSections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chatSections[indexPath.section].chats[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
        cell.configure(with: chat)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }

    // свайп для удаления
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Удалить") { [weak self] _, _, completion in
            self?.chatSections[indexPath.section].chats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
