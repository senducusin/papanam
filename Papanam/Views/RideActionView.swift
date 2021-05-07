//
//  RideActionView.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/5/21.
//

import UIKit
import MapKit

protocol RideActionViewDelegate: AnyObject {
    func buttonTapped(_ view: RideActionView, rideActionConfig: RideActionConfiguration)
}

class RideActionView: UIView {
    // MARK: - Properties
//    var placemark: MKPlacemark? {
//        didSet {
//            configureWithPlacemark()
//        }
//    }
//
    weak var delegate: RideActionViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
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
        let stack = UIStackView(arrangedSubviews: [nameLabel, addressLabel])
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
    
    private lazy var infoViewWithLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 30
        
        view.addSubview(infoViewLabel)
        infoViewLabel.centerX(inView: view)
        infoViewLabel.centerY(inView: view)
        
        view.isHidden = true
        
        return view
    }()
    
    private let infoViewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
//        button.setTitle("CONFIRM DESTINATION", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(confirmHandler), for: .touchUpInside)
        return button
    }()
    
    var viewModel = RideActionViewModel(config: .requestRide)
    // MARK: - Lifecycle
    init(user:User?){
        super.init(frame: .zero)
        
        if user?.type == .driver {
            viewModel.driver = user
        }else {
            viewModel.passenger = user
        }
        
        viewModel.currentUserType = user?.type
        
        setupUI()
        viewModel.setConfig = { [weak self] vm in
            self?.configureWith(vm)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    @objc private func confirmHandler(){
        delegate?.buttonTapped(self, rideActionConfig: viewModel.config)
    }
    
    // MARK: - Helpers
    private func configureWith(_ vm:RideActionViewModel){
        nameLabel.text = vm.nameText
        addressLabel.text = vm.addressText
        titleLabel.text = vm.titleText
        infoViewLabel.text = vm.infoLabelCharacter
        
        confirmButton.setTitle(vm.buttonDescription, for: .normal)
        confirmButton.isEnabled = vm.buttonShouldEnable
        
        if vm.config == .requestRide {
            infoView.isHidden = false
            infoViewWithLabel.isHidden = true
            
        }else{
            infoViewWithLabel.isHidden = false
            infoView.isHidden = true
            
        }
    }
    
    private func setupUI(){
        backgroundColor = .white
        addShadow()
        
        setupStack()
        setupInfoView()
        setupInfoViewWithLabel()
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
    
    private func setupInfoViewWithLabel(){
        addSubview(infoViewWithLabel)
        infoViewWithLabel.centerX(inView: self)
        infoViewWithLabel.anchor(top:stackView.bottomAnchor,paddingTop: 8, width: 60, height: 60)
    }
    
    private func setupPapanamLabel(){
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.anchor(top:infoView.bottomAnchor, paddingTop: 3)
    }
    
    private func setupSeparatorView(){
        addSubview(separatorView)
        separatorView.anchor(top:titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, height: 0.75)
    }
    
    private func setupConfirmButton(){
        addSubview(confirmButton)
        confirmButton.centerX(inView: self)
        confirmButton.anchor(left:leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingBottom: 32, paddingRight: 12, height: 50)
    }
}
