import UIKit

class RegViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let nameField = CustomTextField(placeholder: "Name")
    private let emailField = CustomTextField(placeholder: "Email")
    private let passwordField = CustomTextField(placeholder: "Password")
    private let confirmPasswordField = CustomTextField(placeholder: "Confirm Password")
    private let registerButton = CustomButton(title: "Register")
    
    var isFormValid: Bool {
        return !(nameField.text?.isEmpty ?? true) &&
               !(emailField.text?.isEmpty ?? true) &&
               !(passwordField.text?.isEmpty ?? true) &&
               !(confirmPasswordField.text?.isEmpty ?? true)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
        registerButton.updateState(isEnabled: false)
        registerForKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Register"
        
        titleLabel.text = "Create Account"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        
        let container = CustomTextFieldContainer(textFields: [
            (nameField, "Name"),
            (emailField, "Email"),
            (passwordField, "Password"),
            (confirmPasswordField, "Confirm Password")
        ])
        
        // Настройка scrollView и contentView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(titleLabel, container, registerButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
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
        ])
    }
    
    // MARK: - Keyboard Handling
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // Находим активное текстовое поле
        var activeField: UITextField?
        if nameField.isFirstResponder {
            activeField = nameField
        } else if emailField.isFirstResponder {
            activeField = emailField
        } else if passwordField.isFirstResponder {
            activeField = passwordField
        } else if confirmPasswordField.isFirstResponder {
            activeField = confirmPasswordField
        }
        
        // Прокручиваем к активному полю
        if let activeField = activeField {
            let rect = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        nameField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc private func textFieldsChanged() {
        registerButton.updateState(isEnabled: isFormValid)
    }
    
    @objc private func registerButtonTapped() {
        guard isFormValid else { return }

        guard passwordField.text == confirmPasswordField.text else {
            showAlert(title: "Ошибка", message: "Пароли не совпадают")
            return
        }

        let name = nameField.text ?? ""
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""

        let newUser = RegisterRequest(name: name, email: email, password: password)

        let loader = showLoader()

        Task {
            do {
                try await AuthService.shared.register(user: newUser)
                loader.dismiss(animated: true)
                showAlert(title: "Регистрация завершена", message: "Теперь войдите в аккаунт") {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                loader.dismiss(animated: true)
                showAlert(title: "Ошибка регистрации", message: error.localizedDescription)
            }
        }
    }
}

