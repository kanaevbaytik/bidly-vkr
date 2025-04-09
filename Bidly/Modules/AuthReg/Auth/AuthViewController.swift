import UIKit

class AuthViewController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordTextField = CustomTextField(placeholder: "Password")
    private let loginButton = CustomButton(title: "Login")
    private let signUpButton = UIButton()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground

        titleLabel.text = "Welcome Back!"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center

        passwordTextField.isSecureTextEntry = true

        signUpButton.setTitle("Don't have an account? Sign Up", for: .normal)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        view.addSubviews(titleLabel, emailTextField, passwordTextField, loginButton, signUpButton)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Setup Actions
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        print("Login with email: \(email), password: \(password)")
    }

    @objc private func signUpButtonTapped() {
        let registerVC = RegViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
