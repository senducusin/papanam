//
//  Login.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

class Login:UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PAPANAM"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textAlignment = .center
        label.textColor = .themeWhiteText
        return label
    }()
    
    private let emailTextField = FormTextField(placeholder: "Email")
    
    private lazy var emailContainerView = FormTextFieldContainer(formTextField: emailTextField, icon: .email)
    
    private let passwordTextField = FormTextField(placeholder: "Password", isSecured: true)
    
    private lazy var passwordContainerView = FormTextFieldContainer(formTextField: passwordTextField, icon: .password)
    
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
    
    // MARK: - Lifecycles
    @objc private func loginHandler(){
        print("DEBUG: login")
    }
    
    @objc private func dontHaveAccountHandler(){
        print("DEBUG: don't have an account")
    }
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .themeBlack
        
        setupTitleLabel()
        setupStack()
        setupDontHaveAccountButton()
    }
    
    private func setupTitleLabel(){
        view.addSubview(titleLabel)
        let padding:CGFloat = 10
        titleLabel.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: padding, paddingRight: padding)
    }
    
    private func setupStack(){
        let paddingSides:CGFloat = 16
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
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
