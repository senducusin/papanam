//
//  PickupController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/6/21.
//

import UIKit
import MapKit

class PickupController: UIViewController {
    // MARK: - Properties
    
    let viewModel: PickupViewModel
    
    private let mapView = MKMapView()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.cancel, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissHandler), for:.touchUpInside )
        return button
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleAcceptTrip), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitle("Accept Trip", for: .normal)
        return button
    }()
    
    private let pickupLabel: UILabel = {
        let label = UILabel()
        label.text = "Would you like to pickup this passenger?"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel, pickupLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Lifecycle
    init(trip: Trip){
        self.viewModel = PickupViewModel(trip: trip)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Selectors
    @objc private func dismissHandler(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleAcceptTrip(){
        print("DEBUG: accept")
    }
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .themeBlack
        setupDismissButton()
        setupMapView()
        setupStack()
        setupButton()
        
        configure()
    }
    
    private func setupDismissButton(){
        view.addSubview(dismissButton)
        dismissButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, left:view.leftAnchor, paddingLeft: 16)
    }
    
    private func setupMapView(){
        view.addSubview(mapView)
        mapView.setDimensions(height: 270, width: 270)
        mapView.layer.cornerRadius = 135
        mapView.centerX(inView: view)
        mapView.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 84)
    }
    
    
    private func setupStack(){
        view.addSubview(labelStack)
        labelStack.centerX(inView: view)
        labelStack.anchor(top:mapView.bottomAnchor, paddingTop: 24)
    }
    
    private func setupButton(){
        view.addSubview(acceptButton)
        acceptButton.centerX(inView: view)
        acceptButton.anchor(top:labelStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32, height: 50)
    }
    
    private func configure(){
        let region = viewModel.region
        mapView.setRegion(region, animated: false)
        mapView.addAnnotation(viewModel.placeAnnotation)
        
        titleLabel.text = viewModel.title
        addressLabel.text = viewModel.address
    }
    
    
}
