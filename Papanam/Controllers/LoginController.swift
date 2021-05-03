//
//  LoginController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

class LoginController:UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = .createAppLabel()
    
    private let emailTextField: FormTextField = {
        let textField = FormTextField(placeholder: "Email")
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var emailContainerView = FormFieldContainer(formTextField: emailTextField, icon: .email)
    
    private let passwordTextField: FormTextField = {
        let textField = FormTextField(placeholder: "Password", isSecured: true)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordContainerView = FormFieldContainer(formTextField: passwordTextField, icon: .password)
    
    private lazy var loginButton: FormButton = {
        let button = FormButton(type: .system)
        button.title = "Log in"
        button.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var dontHaveAccountButton: FormAttributedButton = {
        let button = FormAttributedButton(type: .system)
        button.titleWithQuestionMark = "Don't have an account? Sign Up"
        button.addTarget(self, action: #selector(dontHaveAccountHandler), for: .touchUpInside)
        return button
    }()
    
    private var viewModel = LoginViewModel()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Selectors
    @objc private func loginHandler(){
        guard let email = viewModel.email,
              let password = viewModel.password else {return}
        
        AuthService.loginUserWith(email: email, password: password) { error in
            if let error = error{
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: Successfully logged in")
        }
    }
    
    @objc private func dontHaveAccountHandler(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func textDidChange(_ sender: UITextField){
        switch sender {
        case emailTextField:
            viewModel.email = sender.text
            
        case passwordTextField:
            viewModel.password = sender.text
            
        default:
            break
        }
        
        loginButton.isEnabled = viewModel.formIsValid
    }
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .themeBlack
        
        setupNavigation()
        setupTitleLabel()
        setupStack()
        setupDontHaveAccountButton()
    }
    
    private func clearForm(){
        emailTextField.text = ""
        passwordTextField.text = ""
        viewModel.clearForm()
        loginButton.isEnabled = viewModel.formIsValid
    }
    
    private func setupNavigation(){
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTitleLabel(){
        view.addSubview(titleLabel)
        let padding:CGFloat = 10
        titleLabel.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: padding, paddingRight: padding)
    }
    
    private func setupStack(){
        let paddingSides:CGFloat = 16
        let stackView = UIStackView(arrangedSubviews: [
                                        emailContainerView,
                                        passwordContainerView,
                                        loginButton])
        stackView.spacing = 24
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top:titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: paddingSides, paddingRight: paddingSides)
    }
    
    private func setupDontHaveAccountButton(){
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
    }
    
}
