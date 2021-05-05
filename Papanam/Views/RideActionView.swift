//
//  RideActionView.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/5/21.
//

import UIKit

class RideActionView: UIView {
    // MARK: - Properties
    private let papanamLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.text = "PAPANAM"
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "Title"
        label.textAlignment = .center
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Address"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 30
        
        let imageView = UIImageView()
        imageView.image = UIImage.car
        imageView.tintColor = .white
        imageView.setDimensions(height: 34, width: 34)
        
        view.addSubview(imageView)
        imageView.centerY(inView: view)
        imageView.centerX(inView: view)
        
        return view
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("CONFIRM PAPANAM", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(confirmHandler), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    @objc private func confirmHandler(){
        print("DEBUG: confirm")
    }
    
    // MARK: - Helpers
    private func setupUI(){
        backgroundColor = .white
        addShadow()
        
        setupStack()
        setupInfoView()
        setupPapanamLabel()
        setupSeparatorView()
        setupConfirmButton()
    }
    
    private func setupStack(){
        addSubview(stackView)
        stackView.centerX(inView: self)
        stackView.anchor(top:topAnchor, paddingTop: 12)
    }
    
    private func setupInfoView(){
        addSubview(infoView)
        infoView.centerX(inView: self)
        infoView.anchor(top:stackView.bottomAnchor,paddingTop: 8, width: 60, height: 60)
    }
    
    private func setupPapanamLabel(){
        addSubview(papanamLabel)
        papanamLabel.centerX(inView: self)
        papanamLabel.anchor(top:infoView.bottomAnchor, paddingTop: 3)
    }
    
    private func setupSeparatorView(){
        addSubview(separatorView)
        separatorView.anchor(top:papanamLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, height: 0.75)
    }
    
    private func setupConfirmButton(){
        addSubview(confirmButton)
        confirmButton.centerX(inView: self)
        confirmButton.anchor(left:leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingBottom: 32, paddingRight: 12, height: 50)
    }
}
