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
    
    private let emailTextField = FormTextField(placeholder: "Email")
    
    private lazy var emailContainerView = FormFieldContainer(formTextField: emailTextField, icon: .email)
    
    private let passwordTextField = FormTextField(placeholder: "Password", isSecured: true)
    
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
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Selectors
    @objc private func loginHandler(){
        print("DEBUG: login")
    }
    
    @objc private func dontHaveAccountHandler(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .themeBlack

        setupNavigation()
        setupTitleLabel()
        setupStack()
        setupDontHaveAccountButton()
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
