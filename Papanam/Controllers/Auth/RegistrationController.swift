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
    
    private lazy var emailTextField:FormTextField = {
        let textField = FormTextField(placeholder: "Email")
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    private lazy var emailContainerView = FormFieldContainer(formTextField: emailTextField, icon: .email)
    
    private lazy var fullnameTextField:FormTextField = {
        let textField = FormTextField(placeholder: "Full Name")
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    private lazy var fullnameContainerView = FormFieldContainer(formTextField: fullnameTextField, icon: .fullname)
    
    private lazy var passwordTextField: FormTextField = {
        
        let textField = FormTextField(placeholder: "Password", isSecured: true)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
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
    
    private var activeTextField: UITextField? = nil
    
    private var viewModel = RegistrationViewModel()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotifcationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Selectors
    @objc private func signupHandler(){
        guard let email = viewModel.email,
              let password = viewModel.password,
              let fullname = viewModel.fullname,
              let userType = UserType(rawValue: userTypeSegmentedControl.selectedSegmentIndex) else {return}
        
        let newUser = NewUser(email: email, fullname: fullname, userType: userType, password: password)
        
        AuthService.signupNewUser(newUser) { [weak self] error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            self?.clearForm()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func alreadyHaveAnAccountHandler(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            adjustViewToFitKeyboard(keyboardFrame: keyboardFrame)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    @objc func textDidChange(_ sender: UITextField){
        
        switch sender {
        
        case emailTextField:
            viewModel.email = sender.text
            
        case fullnameTextField:
            viewModel.fullname = sender.text
            
        case passwordTextField:
            viewModel.password = sender.text
            
        default:
            break
        }
        
        sigupButton.isEnabled = viewModel.formIsValid
    }
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .themeBlack
        setupTitleLabel()
        setupStack()
        setupAlreadyHaveAnAccountButton()
    }
    
    private func clearForm(){
        emailTextField.text = ""
        fullnameTextField.text = ""
        passwordTextField.text = ""
        userTypeSegmentedControl.selectedSegmentIndex = 0
        viewModel.clearForm()
        sigupButton.isEnabled = viewModel.formIsValid
    }
    
    private func adjustViewToFitKeyboard(keyboardFrame:NSValue){
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        let bounds = UIScreen.main.bounds
        let screenHeight = bounds.size.height
        
        let textFieldParentViewOriginY = activeTextField!.superview!.frame.origin.y
        let textFieldParentFrameHeight = activeTextField!.superview!.frame.height
        
        let topElementWithHeight = titleLabel.frame.height
        let topElementPadding:CGFloat = 40
        
        let visibleUI = screenHeight - (CGFloat(textFieldParentViewOriginY) + CGFloat(textFieldParentFrameHeight) + CGFloat(topElementWithHeight) + CGFloat(topElementPadding))
        
        if visibleUI < keyboardHeight + 25 {
            if view.frame.origin.y == 0 {
                
                let additionalHeight = abs(visibleUI - keyboardHeight) + 25
                self.view.frame.origin.y -= additionalHeight
            }
        }
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
    
    private func setupNotifcationObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UITextField Delegate
extension RegistrationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
}
