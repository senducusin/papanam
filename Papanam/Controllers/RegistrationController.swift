//
//  RegistrationController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

class RegistrationController: UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = .createAppLabel()
    
    private let emailTextField = FormTextField(placeholder: "Email")
    private lazy var emailContainerView = FormFieldContainer(formTextField: emailTextField, icon: .email)
    
    private let fullnameTextField = FormTextField(placeholder: "Full Name")
    private lazy var fullnameContainerView = FormFieldContainer(formTextField: fullnameTextField, icon: .fullname)
    
    private let passwordTextField = FormTextField(placeholder: "Password", isSecured: true)
    private lazy var passwordContainerView = FormFieldContainer(formTextField: passwordTextField, icon: .password)
    
    private let userTypeSegmentedControl:UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Rider", "Driver"])
        segmentedControl.backgroundColor = .themeBlack
        segmentedControl.tintColor = .themeWhiteText
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var userTypeContainerView = FormFieldContainer(segmentedControl: userTypeSegmentedControl, icon: .userType)
    
    private lazy var sigupButton: FormButton = {
        let button = FormButton(type: .system)
        button.title = "Sign Up"
        button.addTarget(self, action: #selector(signupHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var alreadyHaveAnAccountButton: FormAttributedButton = {
        let button = FormAttributedButton(type: .system)
        button.titleWithQuestionMark = "Already have an account? Log in"
        button.addTarget(self, action: #selector(alreadyHaveAnAccountHandler), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Selectors
    @objc private func signupHandler(){
        print("DEBUG: sign up")
    }
    
    @objc private func alreadyHaveAnAccountHandler(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .themeBlack
        
        setupTitleLabel()
        setupStack()
        setupAlreadyHaveAnAccountButton()
    }
    
    private func setupTitleLabel(){
        view.addSubview(titleLabel)
        let padding:CGFloat = 10
        titleLabel.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: padding, paddingRight: padding)
    }
    
    private func setupStack(){
        let stack = UIStackView(arrangedSubviews: [
            emailContainerView,
            fullnameContainerView,
            passwordContainerView,
            userTypeContainerView,
            sigupButton
        ])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top:titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
    }
    
    private func setupAlreadyHaveAnAccountButton(){
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
    }
}
