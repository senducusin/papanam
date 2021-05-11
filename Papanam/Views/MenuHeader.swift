//
//  MenuHeader.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/10/21.
//

import UIKit

class MenuHeader: UIView {
    // MARK: - Properties
    private let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Fullname"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Address"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    var user: User? {
        didSet{
            configure()
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    private func configure(){
        guard let user = user else {return}
        fullnameLabel.text = user.fullname
        emailLabel.text = user.email
    }
    
    private func setupUI(){
        backgroundColor = .themeBlack
        
        setupProfileImageView()
        setupStack()
    }
    
    private func setupProfileImageView(){
        addSubview(profileImageView)
        
        let dimension:CGFloat = 64
        profileImageView.anchor(top:safeAreaLayoutGuide.topAnchor, left:leftAnchor, paddingTop: 4, paddingLeft: 12, width: dimension, height: dimension)
        profileImageView.layer.cornerRadius = dimension/2
    }
    
    private func setupStack(){
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, emailLabel])
        stack.spacing = 4
        stack.distribution = .fillEqually
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
}
