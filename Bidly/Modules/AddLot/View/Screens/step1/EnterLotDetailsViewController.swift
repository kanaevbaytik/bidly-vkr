import UIKit

class EnterLotDetailsViewController: UIViewController, DropdownHandlerDelegate, DatePickerHandlerDelegate {
    weak var delegate: LotStepDelegate?
    private let viewModel: CreateLotViewModel
    
    private let titleField = CustomTextField(placeholder: "Enter title")
    private let categoryField = CustomTextField(placeholder: "Select category")
    private let dateField = CustomTextField(placeholder: "Выберите дату окончания")
    private let nextButton = CustomButton(title: "Далее")
    
    private var dropdownHandler: DropdownHandler?
    private var datePickerHandler: DatePickerHandler?
    
    private let categories = [
        "Электроника", "Одежда и обувь", "Дом и сад", "Детские товары",
        "Хобби и развлечения", "Автотовары", "Спорт и отдых",
        "Антиквариат", "Животные", "Прочее"
    ]
    
    var isFormValid: Bool {
        return !(titleField.text?.isEmpty ?? true) &&
               !(categoryField.text?.isEmpty ?? true) &&
               !(dateField.text?.isEmpty ?? true)
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
        
        setupUI()
        setupDropdownHandler()
        setupDatePickerHandler()
        
        titleField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.updateState(isEnabled: false)
    }
    
    private func setupUI() {
        let mainContainer = CustomTextFieldContainer(textFields: [
            (titleField, "Title"),
            (categoryField, "Category")
        ])
        
        let dateContainer = CustomTextFieldContainer(textFields: [
            (dateField, "Окончание аукциона")
        ])
        
        view.addSubviews(mainContainer, dateContainer, nextButton)
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
            dateContainer.translatesAutoresizingMaskIntoConstraints = false
            nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),

            dateContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateContainer.topAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: 20),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            ])
    }
    
    private func setupDropdownHandler() {
        dropdownHandler = DropdownHandler(
            textField: categoryField,
            items: categories,
            parentView: view,
            delegate: self
        )
    }
    
    private func setupDatePickerHandler() {
        datePickerHandler = DatePickerHandler(
            textField: dateField,
            delegate: self
        )
    }
    
    // MARK: - DropdownHandlerDelegate
    func didSelectItem(_ item: String) {
        textFieldsChanged()
    }
    
    // MARK: - DatePickerHandlerDelegate
    func didSelectDate(_ date: String) {
        textFieldsChanged()
    }
    
    @objc private func textFieldsChanged() {
        nextButton.updateState(isEnabled: isFormValid)
    }
    
    @objc private func nextButtonTapped() {
        if isFormValid {
            let success = viewModel.setBasicDetails(
                title: titleField.text,
                category: categoryField.text,
                endDateString: dateField.text
            )
            
            if success {
                delegate?.goToNextPage()
            }
        }
    }
}

//import UIKit
//
//class EnterLotDetailsViewController: UIViewController {
//    weak var delegate: LotStepDelegate?
//    private let viewModel: CreateLotViewModel
//
//    private let titleField = CustomTextField(placeholder: "Enter title")
//    private let categoryField = CustomTextField(placeholder: "Select category")
//    private let dateField = CustomTextField(placeholder: "Выберите дату окончания")
//    private let nextButton = CustomButton(title: "Next")
//
//    private let dropdownArrow = UIImageView()
//    private let dropdownTableView = UITableView()
//    private var isDropdownVisible = false
//
//    private let categories = [
//        "Электроника",
//        "Одежда и обувь",
//        "Дом и сад",
//        "Детские товары",
//        "Хобби и развлечения",
//        "Автотовары",
//        "Спорт и отдых",
//        "Антиквариат",
//        "Животные",
//        "Прочее"
//    ]
//
//    var isFormValid: Bool {
//        return !(titleField.text?.isEmpty ?? true) &&
//               !(categoryField.text?.isEmpty ?? true) &&
//               !(dateField.text?.isEmpty ?? true)
//    }
//
//    init(viewModel: CreateLotViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        navigationItem.title = "Создать лот"
//
//        let mainContainer = CustomTextFieldContainer(textFields: [
//            (titleField, "Title"),
//            (categoryField, "Category")
//        ])
//
//        let dateContainer = CustomTextFieldContainer(textFields: [
//            (dateField, "Окончание аукциона")
//        ])
//
//        view.addSubviews(mainContainer, dateContainer, nextButton, dropdownTableView)
//
//        setupConstraints(mainContainer, dateContainer)
//        setupDropdown()
//        setupDatePicker()
//
//        titleField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
//        categoryField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
//        dateField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
//
//        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
//        nextButton.updateState(isEnabled: false)
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryFieldTapped))
//        categoryField.addGestureRecognizer(tapGesture)
//        categoryField.isUserInteractionEnabled = true
//    }
//
//    private func setupConstraints(_ mainContainer: UIView, _ dateContainer: UIView) {
//        mainContainer.translatesAutoresizingMaskIntoConstraints = false
//        dateContainer.translatesAutoresizingMaskIntoConstraints = false
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            mainContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            mainContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            mainContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
//
//            dateContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            dateContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            dateContainer.topAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: 20),
//
//            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            nextButton.heightAnchor.constraint(equalToConstant: 50),
//
//            dropdownTableView.leadingAnchor.constraint(equalTo: categoryField.leadingAnchor),
//            dropdownTableView.trailingAnchor.constraint(equalTo: categoryField.trailingAnchor),
//            dropdownTableView.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: 4),
//            dropdownTableView.heightAnchor.constraint(equalToConstant: 0)
//        ])
//    }
//    
//    private func setupDropdown() {
//        dropdownArrow.image = UIImage(systemName: "chevron.right")
//        dropdownArrow.tintColor = .gray
//        dropdownArrow.translatesAutoresizingMaskIntoConstraints = false
//        categoryField.addSubview(dropdownArrow)
//
//        NSLayoutConstraint.activate([
//            dropdownArrow.centerYAnchor.constraint(equalTo: categoryField.centerYAnchor),
//            dropdownArrow.trailingAnchor.constraint(equalTo: categoryField.trailingAnchor, constant: -12),
//            dropdownArrow.widthAnchor.constraint(equalToConstant: 12),
//            dropdownArrow.heightAnchor.constraint(equalToConstant: 12)
//        ])
//
//        dropdownTableView.isScrollEnabled = false
//        dropdownTableView.layer.cornerRadius = 10
//        dropdownTableView.layer.borderWidth = 1
//        dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
//        dropdownTableView.dataSource = self
//        dropdownTableView.delegate = self
//        dropdownTableView.isHidden = true
//    }
//
//    private func setupDatePicker() {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .dateAndTime
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.minimumDate = Date()
//
//        if #available(iOS 13.4, *) {
//            datePicker.locale = Locale(identifier: "ru_RU")
//        }
//
//        dateField.inputView = datePicker
//
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePickingDate))
//        toolbar.setItems([doneButton], animated: false)
//        dateField.inputAccessoryView = toolbar
//    }
//
//    @objc private func donePickingDate() {
//        if let datePicker = dateField.inputView as? UIDatePicker {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd.MM.yyyy HH:mm"
//            dateField.text = formatter.string(from: datePicker.date)
//            textFieldsChanged()
//        }
//        view.endEditing(true)
//    }
//
//    @objc private func categoryFieldTapped() {
//        toggleDropdown()
//    }
//
//    private func toggleDropdown() {
//        isDropdownVisible.toggle()
//
//        if isDropdownVisible {
//            dropdownTableView.isHidden = false
//            rotateArrow(down: true)
//
//            UIView.animate(withDuration: 0.3) {
//                self.dropdownTableView.constraints.first { $0.firstAttribute == .height }?.constant = CGFloat(self.categories.count * 44)
//                self.view.layoutIfNeeded()
//            }
//        } else {
//            hideDropdown()
//        }
//    }
//
//    private func hideDropdown() {
//        isDropdownVisible = false
//        rotateArrow(down: false)
//
//        UIView.animate(withDuration: 0.3, animations: {
//            self.dropdownTableView.constraints.first { $0.firstAttribute == .height }?.constant = 0
//            self.view.layoutIfNeeded()
//        }) { _ in
//            self.dropdownTableView.isHidden = true
//        }
//    }
//
//    private func rotateArrow(down: Bool) {
//        UIView.animate(withDuration: 0.2) {
//            self.dropdownArrow.transform = down ? CGAffineTransform(rotationAngle: .pi / 2) : .identity
//        }
//    }
//
//    @objc private func textFieldsChanged() {
//        nextButton.updateState(isEnabled: isFormValid)
//    }
//
//    @objc private func nextButtonTapped() {
//        if isFormValid {
//            let success = viewModel.setBasicDetails(
//                title: titleField.text,
//                category: categoryField.text,
//                endDateString: dateField.text
//            )
//            
//            if success {
//                delegate?.goToNextPage()
//            }
//        }
//    }
//}
//
//// MARK: - UITableViewDataSource, UITableViewDelegate
//extension EnterLotDetailsViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        cell.textLabel?.text = categories[indexPath.row]
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        categoryField.text = categories[indexPath.row]
//        hideDropdown()
//        textFieldsChanged()
//    }
//}
