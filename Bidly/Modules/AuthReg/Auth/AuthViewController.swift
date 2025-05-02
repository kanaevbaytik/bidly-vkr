import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let emailField = CustomTextField(placeholder: "Email")
    private let passwordField = CustomTextField(placeholder: "Password")
    private let loginButton = CustomButton(title: "Login")
    private let signUpButton = UIButton()

    var isFormValid: Bool {
        return !(emailField.text?.isEmpty ?? true) &&
               !(passwordField.text?.isEmpty ?? true)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
        loginButton.updateState(isEnabled: false)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Login"
        
        titleLabel.text = "Welcome Back!"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        
        passwordField.isSecureTextEntry = true
        
        signUpButton.setTitle("Don't have an account? Sign Up", for: .normal)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        let container = CustomTextFieldContainer(textFields: [
            (emailField, "Email"),
            (passwordField, "Password")
        ])
        
        view.addSubviews(titleLabel, container, loginButton, signUpButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        emailField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc private func textFieldsChanged() {
        loginButton.updateState(isEnabled: isFormValid)
    }
    
    @objc private func loginButtonTapped() {
        guard isFormValid else { return }
        print("Login with email: \(emailField.text ?? ""), password: \(passwordField.text ?? "")")
    }
    
    @objc private func signUpButtonTapped() {
        let registerVC = RegViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
