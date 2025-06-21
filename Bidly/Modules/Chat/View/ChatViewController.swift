//
//  MyBidsViewController.swift
//  Bidly
//MyBidsViewController
//  Created by Baytik  on 9/3/25.
//

import UIKit

struct ChatMessage {
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: Date
}

class ChatViewController: UIViewController {

    private var messages: [ChatMessage] = [
        ChatMessage(text: "Здравствуйте! Этот лот ещё доступен?", isFromCurrentUser: false, timestamp: Date()),
        ChatMessage(text: "Да, конечно. Можете сделать ставку или задать вопросы.", isFromCurrentUser: true, timestamp: Date())
    ]
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.keyboardDismissMode = .interactive
        tv.dataSource = self
        tv.delegate = self
        tv.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        return tv
    }()
    
    private let inputContainerView = UIView()
    private let messageInputTextView = UITextView()
    private let sendButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Сообщения"
        setupInputComponents()
        setupTableView()
        setupKeyboardObservers()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupInputComponents() {
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.backgroundColor = UIColor.systemGray6
        view.addSubview(inputContainerView)

        messageInputTextView.translatesAutoresizingMaskIntoConstraints = false
        messageInputTextView.font = UIFont.systemFont(ofSize: 16)
        messageInputTextView.layer.cornerRadius = 16
        messageInputTextView.backgroundColor = .white
        messageInputTextView.text = ""
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = UIColor(hex: "#7B61FF")
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)

        inputContainerView.addSubview(messageInputTextView)
        inputContainerView.addSubview(sendButton)

        NSLayoutConstraint.activate([
            inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerView.heightAnchor.constraint(equalToConstant: 56),

            messageInputTextView.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 8),
            messageInputTextView.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -8),
            messageInputTextView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 16),
            messageInputTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),

            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -16),
            sendButton.widthAnchor.constraint(equalToConstant: 28),
            sendButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    @objc private func handleSend() {
        guard !messageInputTextView.text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newMessage = ChatMessage(text: messageInputTextView.text, isFromCurrentUser: true, timestamp: Date())
        messages.append(newMessage)
        messageInputTextView.text = ""
        tableView.reloadData()
        scrollToBottom()
    }

    private func scrollToBottom() {
        let lastIndex = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func handleKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardVisible = endFrame.origin.y < UIScreen.main.bounds.height
        let bottomPadding: CGFloat = keyboardVisible ? endFrame.height - view.safeAreaInsets.bottom : 0

        UIView.animate(withDuration: duration) {
            self.inputContainerView.transform = CGAffineTransform(translationX: 0, y: -bottomPadding)
            self.tableView.contentInset.bottom = keyboardVisible ? bottomPadding + 56 : 56
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}
