//
//  RulesViewController.swift
//  Bidly
//
//  Created by Baytik  on 8/3/25.
//RulesViewController

import UIKit

class RulesViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let sections: [(title: String, description: String)] = [
        (
            "Что такое аукцион?",
            "Аукцион — это способ покупки и продажи товаров, при котором пользователи предлагают свою цену. Продавец указывает минимальную цену, с которой начинается торг. Выигрывает тот, кто сделает наивысшую ставку до завершения времени аукциона. Это прозрачная, динамичная и конкурентная модель торговли."
        ),
        (
            "Как подаются ставки?",
            "Чтобы подать ставку, достаточно нажать кнопку \"Сделать ставку\" на странице товара. Ваша ставка должна быть выше текущей, с учетом минимального шага ставки. Если кто-то предложит цену выше, вы получите уведомление. Ставки являются обязательством — отменить их нельзя."
        ),
        (
            "Минимальный шаг ставки",
            "Шаг ставки — это минимальная сумма, на которую можно повысить текущую цену. Например, если текущая ставка 1000 сом, а шаг 100 сом, следующая ставка должна быть не менее 1100 сом. Размер шага рассчитывается автоматически при создании лота и зависит от начальной цены."
        ),
        (
            "Автоматическое перебивание",
            "Вы можете указать максимальную сумму, которую готовы отдать. Система будет автоматически перебивать ставки других пользователей, пока не достигнет вашего лимита. Это позволяет не следить за торгом в реальном времени и всё равно выигрывать. Максимальная ставка не отображается другим участникам."
        ),
        (
            "Окончание аукциона",
            "Аукцион завершается в точное время, указанное на странице товара. После завершения никто не может подать ставку. Победитель определяется автоматически, и продавец получает его контакты. Покупатель получает подтверждение по почте и в приложении."
        ),
        (
            "Связь с поддержкой",
            "Если у вас возникли вопросы по ставкам, автоматическому перебиванию или техническим моментам, свяжитесь с нашей службой поддержки: support@bidly.kg. Мы постараемся помочь вам как можно быстрее!"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Правила"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.preservesSuperviewLayoutMargins = false
        tableView.separatorStyle = .singleLine
        tableView.register(RuleCell.self, forCellReuseIdentifier: "RuleCell")
        tableView.tableHeaderView = makeHeader()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func makeHeader() -> UIView {
        let container = UIView()
        
        let icon = UIImageView(image: UIImage(systemName: "hammer.circle.fill"))
        icon.tintColor = .systemPurple
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Об аукционе"
        title.font = .boldSystemFont(ofSize: 26)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(icon)
        container.addSubview(title)
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            icon.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40),
            
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            title.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24)
        ])
        
        container.layoutIfNeeded()
        let size = container.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        container.frame = CGRect(origin: .zero, size: size)
        
        return container
    }
}

extension RulesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RuleCell", for: indexPath) as! RuleCell
        cell.configure(text: section.description)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

final class RuleCell: UITableViewCell {
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(text: String) {
        descriptionLabel.text = text
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}



//(
//    "Что такое аукцион?",
//    "Аукцион — это способ покупки и продажи товаров, при котором пользователи предлагают свою цену. Продавец указывает минимальную цену, с которой начинается торг. Выигрывает тот, кто сделает наивысшую ставку до завершения времени аукциона. Это прозрачная, динамичная и конкурентная модель торговли."
//),
//(
//    "Как подаются ставки?",
//    "Чтобы подать ставку, достаточно нажать кнопку \"Сделать ставку\" на странице товара. Ваша ставка должна быть выше текущей, с учетом минимального шага ставки. Если кто-то предложит цену выше, вы получите уведомление. Ставки являются обязательством — отменить их нельзя."
//),
//(
//    "Минимальный шаг ставки",
//    "Шаг ставки — это минимальная сумма, на которую можно повысить текущую цену. Например, если текущая ставка 1000 сом, а шаг 100 сом, следующая ставка должна быть не менее 1100 сом. Размер шага рассчитывается автоматически при создании лота и зависит от начальной цены."
//),
//(
//    "Автоматическое перебивание",
//    "Вы можете указать максимальную сумму, которую готовы отдать. Система будет автоматически перебивать ставки других пользователей, пока не достигнет вашего лимита. Это позволяет не следить за торгом в реальном времени и всё равно выигрывать. Максимальная ставка не отображается другим участникам."
//),
//(
//    "Окончание аукциона",
//    "Аукцион завершается в точное время, указанное на странице товара. После завершения никто не может подать ставку. Победитель определяется автоматически, и продавец получает его контакты. Покупатель получает подтверждение по почте и в приложении."
//),
//(
//    "Связь с поддержкой",
//    "Если у вас возникли вопросы по ставкам, автоматическому перебиванию или техническим моментам, свяжитесь с нашей службой поддержки: support@bidly.kg. Мы постараемся помочь вам как можно быстрее!"
//)
