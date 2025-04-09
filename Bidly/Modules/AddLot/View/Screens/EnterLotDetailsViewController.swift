import UIKit

class EnterLotDetailsViewController: UIViewController {
    weak var delegate: LotStepDelegate?
    private let viewModel: CreateLotViewModel

    private let titleField = CustomTextField(placeholder: "Enter title")
    private let categoryField = CustomTextField(placeholder: "Select category")
    private let nextButton = CustomButton(title: "Next")

    private let dropdownArrow = UIImageView()
    private let dropdownTableView = UITableView()
    private var isDropdownVisible = false

    private let categories = [
        "Электроника",
        "Одежда и обувь",
        "Дом и сад",
        "Детские товары",
        "Хобби и развлечения",
        "Автотовары",
        "Спорт и отдых",
        "Антиквариат",
        "Животные",
        "Прочее"
    ]

    var isFormValid: Bool {
        return !(titleField.text?.isEmpty ?? true) && !(categoryField.text?.isEmpty ?? true)
    }

    init(viewModel: CreateLotViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Создать лот"

        let textFieldContainer = CustomTextFieldContainer(textFields: [
            (titleField, "Title"),
            (categoryField, "Category")
        ])

        view.addSubview(textFieldContainer)
        view.addSubview(nextButton)
        view.addSubview(dropdownTableView)

        setupConstraints(textFieldContainer)
        setupDropdown()

        titleField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        categoryField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.updateState(isEnabled: false)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryFieldTapped))
        categoryField.addGestureRecognizer(tapGesture)
        categoryField.isUserInteractionEnabled = true
    }

    private func setupConstraints(_ textFieldContainer: UIView) {
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50),

            dropdownTableView.leadingAnchor.constraint(equalTo: categoryField.leadingAnchor),
            dropdownTableView.trailingAnchor.constraint(equalTo: categoryField.trailingAnchor),
            dropdownTableView.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: 4),
            dropdownTableView.heightAnchor.constraint(equalToConstant: 0) // изначально скрыт
        ])
    }

    private func setupDropdown() {
        dropdownArrow.image = UIImage(systemName: "chevron.right")
        dropdownArrow.tintColor = .gray
        dropdownArrow.translatesAutoresizingMaskIntoConstraints = false
        categoryField.addSubview(dropdownArrow)

        NSLayoutConstraint.activate([
            dropdownArrow.centerYAnchor.constraint(equalTo: categoryField.centerYAnchor),
            dropdownArrow.trailingAnchor.constraint(equalTo: categoryField.trailingAnchor, constant: -12),
            dropdownArrow.widthAnchor.constraint(equalToConstant: 12),
            dropdownArrow.heightAnchor.constraint(equalToConstant: 12)
        ])

        dropdownTableView.isScrollEnabled = false
        dropdownTableView.layer.cornerRadius = 10
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
        dropdownTableView.dataSource = self
        dropdownTableView.delegate = self
        dropdownTableView.isHidden = true
    }

    @objc private func categoryFieldTapped() {
        toggleDropdown()
    }

    private func toggleDropdown() {
        isDropdownVisible.toggle()

        if isDropdownVisible {
            dropdownTableView.isHidden = false
            rotateArrow(down: true)

            UIView.animate(withDuration: 0.3) {
                self.dropdownTableView.constraints.first { $0.firstAttribute == .height }?.constant = CGFloat(self.categories.count * 44)
                self.view.layoutIfNeeded()
            }
        } else {
            hideDropdown()
        }
    }

    private func hideDropdown() {
        isDropdownVisible = false
        rotateArrow(down: false)

        UIView.animate(withDuration: 0.3, animations: {
            self.dropdownTableView.constraints.first { $0.firstAttribute == .height }?.constant = 0
            self.view.layoutIfNeeded()
        }) { _ in
            self.dropdownTableView.isHidden = true
        }
    }

    private func rotateArrow(down: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.dropdownArrow.transform = down ? CGAffineTransform(rotationAngle: .pi / 2) : .identity
        }
    }

    @objc private func textFieldsChanged() {
        nextButton.updateState(isEnabled: isFormValid)
    }

    @objc private func nextButtonTapped() {
        if isFormValid {
            delegate?.goToNextPage()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension EnterLotDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryField.text = categories[indexPath.row]
        hideDropdown()
        textFieldsChanged()
    }
}
