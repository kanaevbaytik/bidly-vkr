import UIKit

final class RegViewController: UIViewController {

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let nameField = CustomTextField(placeholder: "Name")
    private let emailField = CustomTextField(placeholder: "Email")
    private let passwordField = CustomTextField(placeholder: "Password", isSecure: true)
    private let confirmPasswordField = CustomTextField(placeholder: "Confirm Password", isSecure: true)
    private let registerButton = CustomButton(title: "Register")

    private var activeField: UITextField?

    // MARK: - Computed
    private var isFormValid: Bool {
        guard
            let name = nameField.text, !name.isEmpty,
            let email = emailField.text, email.isValidEmail(),
            let password = passwordField.text, !password.isEmpty,
            let confirm = confirmPasswordField.text, !confirm.isEmpty,
            password == confirm
        else {
            return false
        }
        return true
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupKeyboardHandling()
        registerButton.updateState(isEnabled: false)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "Register"
        view.backgroundColor = .systemGroupedBackground
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true

        titleLabel.text = "Create Account"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center

        let container = CustomTextFieldContainer(textFields: [
            (nameField, "Name"),
            (emailField, "Email"),
            (passwordField, "Password"),
            (confirmPasswordField, "Confirm Password")
        ])

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubviews(titleLabel, container, registerButton)
        [titleLabel, container, registerButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate(
            scrollView.pinToEdges(of: view) +
            contentView.pinToEdges(of: scrollView) +
            [
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                
                container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
                container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                
                registerButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 30),
                registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                registerButton.heightAnchor.constraint(equalToConstant: 50),
                registerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ]
        )
    }

    // MARK: - Actions
    private func setupActions() {
        [nameField, emailField, passwordField, confirmPasswordField].forEach {
            $0.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
            $0.delegate = self
        }
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
    }

    @objc private func endEditing() {
        view.endEditing(true)
    }

    @objc private func textFieldsChanged() {
        registerButton.updateState(isEnabled: isFormValid)
        // Валидация email и пароля
        if let email = emailField.text, !email.isEmpty, !email.isValidEmail() {
            emailField.showError(message: "Invalid email format")
        } else {
            emailField.hideError()
        }

        if let password = passwordField.text, let confirm = confirmPasswordField.text, !confirm.isEmpty, password != confirm {
            confirmPasswordField.showError(message: "Passwords do not match")
        } else {
            confirmPasswordField.hideError()
        }
    }

    @objc private func registerButtonTapped() {
        guard let name = nameField.text, !name.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Пожалуйста, заполните все поля")
            return
        }

        let request = RegisterRequest(name: name, email: email, password: password)
        registerButton.showLoading(true)

        Task {
            do {
                let response = try await AuthService.shared.register(user: request)
                print("Успешная регистрация: \(response.accessToken)")

                navigateToMainScreen()
            } catch {
                showAlert(title: "Ошибка", message: error.localizedDescription)
            }

            registerButton.showLoading(false)
        }
    }
    
    private func navigateToMainScreen() {
        let mainTabBar = CustomTabBarController()
        mainTabBar.modalPresentationStyle = .fullScreen
        present(mainTabBar, animated: true)
    }



    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 20, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        if let activeField = activeField {
            let rect = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

// MARK: - UITextFieldDelegate
extension RegViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            confirmPasswordField.becomeFirstResponder()
        case confirmPasswordField:
            confirmPasswordField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
