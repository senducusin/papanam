//
//  LocationInputView.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import UIKit

protocol LocationInputViewDelegate: AnyObject {
    func dismissLocationInputView()
}

class LocationInputView: UIView {
    // MARK: - Properties
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "User's Fullname"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let linkingView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let destinationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var startingLocationTextfield: LocationInputTextField = {
        let textField = LocationInputTextField(placeholder: "Current Location")
        textField.backgroundColor = .themeLightGray
        textField.isEnabled = false
        return textField
    }()
    
    private lazy var destinationLocationTextfield: LocationInputTextField = {
        let textField = LocationInputTextField(placeholder: "Enter a destination")
        textField.backgroundColor = .themeDarkGray
        textField.returnKeyType = .search
        return textField
    }()
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: LocationInputViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame:CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc private func backButtonHandler(){
        delegate?.dismissLocationInputView()
    }
    
    // MARK: - Helpers
    private func setupUI(){
        backgroundColor = .white
        addShadow()
        setupBackButton()
        setupTitleLabel()
        setupStartingLocationTextfield()
        setupDestinationLocationTextfield()
        setupStartLocationIndicatorView()
        setupDestinationLocationIndicatorView()
        setupLinkingView()
    }
    
    private func setupStartingLocationTextfield(){
        addSubview(startingLocationTextfield)
        startingLocationTextfield.anchor(top:backButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 40, paddingRight:40, height: 30)
    }
    
    private func setupDestinationLocationTextfield(){
        addSubview(destinationLocationTextfield)
        destinationLocationTextfield.anchor(top:startingLocationTextfield.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 40, paddingRight:40, height: 30)
    }
    
    private func setupBackButton(){
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 25)
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
    }
    
    private func setupStartLocationIndicatorView(){
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.centerY(inView: startingLocationTextfield, leftAnchor: leftAnchor, paddingLeft: 20)
        startLocationIndicatorView.setDimensions(height: 6, width: 6)
        startLocationIndicatorView.layer.cornerRadius = 3
    }
    
    private func setupDestinationLocationIndicatorView(){
        addSubview(destinationIndicatorView)
        destinationIndicatorView.centerY(inView: destinationLocationTextfield, leftAnchor: leftAnchor, paddingLeft: 20)
        destinationIndicatorView.setDimensions(height: 6, width: 6)
    }
    
    private func setupLinkingView(){
        addSubview(linkingView)
        linkingView.centerX(inView: startLocationIndicatorView)
        linkingView.anchor(top:startLocationIndicatorView.bottomAnchor, bottom: destinationIndicatorView.topAnchor, paddingTop: 4, paddingBottom: 4, width: 0.5)
    }
    
    private func configure(){
        guard let user = user else {return}
        titleLabel.text = user.fullname
    }
}
