//
//  PickupController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/6/21.
//

import UIKit
import MapKit

protocol PickupControllerDelegate: AnyObject {
    func didAcceptTrip(_ controller: PickupController, trip: Trip)
}

class PickupController: UIViewController {
    // MARK: - Properties
    
    weak var delegate: PickupControllerDelegate?
    
    let viewModel: PickupViewModel
    
    private let mapView = MKMapView()
    
    private lazy var circularProgressView: CircularProgressView = {
        let frame = CGRect(x: 0, y: 0, width: 360, height: 360)
        let cpView = CircularProgressView(frame: frame)
        cpView.addSubview(mapView)
        
        mapView.centerX(inView: cpView)
        mapView.centerY(inView: cpView, constant: 28)
        
        mapView.setDimensions(height: 268, width: 268)
        mapView.layer.cornerRadius = 268/2
        
        return cpView
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.cancelWithTint, for: .normal)
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
    
    private let pickupAddressTitle: PickupLabel = {
        let label = PickupLabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(white: 1, alpha: 1)
        label.text = "PICKUP"
        return label
    }()
    
    private let pickupAddressLabel: PickupLabel = {
        let label = PickupLabel()
        return label
    }()
    
    private let destinationAddressTitle: PickupLabel = {
        let label = PickupLabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(white: 1, alpha: 1)
        label.text = "DROPOFF"
        return label
    }()
    
    private let destinationAddressLabel: PickupLabel = {
        let label = PickupLabel()
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeWhiteText
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pathLabelStack: UIStackView = {
        let pickup = UIStackView(arrangedSubviews: [pickupAddressTitle, pickupAddressLabel])
        pickup.axis = .vertical
        pickup.distribution = .fillProportionally
        pickup.spacing = 2
        
        let dropoff = UIStackView(arrangedSubviews: [destinationAddressTitle, destinationAddressLabel])
        dropoff.axis = .vertical
        dropoff.distribution = .fillProportionally
        dropoff.spacing = 2
        
        let stack = UIStackView(arrangedSubviews: [pickup, dropoff])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 18
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
        self.perform(#selector(animateProgress),with: nil, afterDelay: 0.5)
    }
    
    // MARK: - Selectors
    @objc private func dismissHandler(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleAcceptTrip(){
        acceptTrip()
    }
    
    @objc private func animateProgress(){
        circularProgressView.animatePulsatingLayer()
        circularProgressView.setProgressWithAnimation(duration: 5, value: 0) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - API
    private func acceptTrip(){
        let controller = self
        let trip = self.viewModel.trip
        DriverService.shared.acceptTrip(viewModel.trip) { [weak self] error, ref in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self?.delegate?.didAcceptTrip(controller, trip: trip)
        }
    }
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .themeBlack
        setupDismissButton()
        setupCircularProgressView()
        setupInfoLabel()
        setupSeparatorView()
        setupStack()
        setupButton()
        
        configure()
    }
    
    private func setupDismissButton(){
        view.addSubview(dismissButton)
        dismissButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, left:view.leftAnchor, paddingLeft: 16)
    }
    
    private func setupCircularProgressView(){
        view.addSubview(circularProgressView)
        circularProgressView.setDimensions(height: 360, width: 360)
        circularProgressView.layer.cornerRadius = 180
        circularProgressView.centerX(inView: view)
        circularProgressView.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 22)
    }
    
    private func setupStack(){
        view.addSubview(pathLabelStack)
        pathLabelStack.centerX(inView: view)
        pathLabelStack.anchor(top:separatorView.bottomAnchor, left:view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
    }
    
    private func setupButton(){
        view.addSubview(acceptButton)
        acceptButton.centerX(inView: view)
        acceptButton.anchor(top:pathLabelStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32, height: 50)
    }
    
    private func setupInfoLabel(){
        view.addSubview(infoLabel)
        infoLabel.anchor(top:circularProgressView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 52, paddingLeft: 32, paddingRight: 32)
    }
    
    private func setupSeparatorView(){
        view.addSubview(separatorView)
        separatorView.anchor(top:infoLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12, height: 0.75)
    }
    
    private func configure(){
        let region = viewModel.region
        
        mapView.setRegion(region, animated: false)
        mapView.addAnnotation(viewModel.placeAnnotation)
        mapView.selectAnnotation(mapView.annotations[0], animated: false)
        
        pickupAddressLabel.text = viewModel.pickupAddress
        destinationAddressLabel.text = viewModel.dropoffAddress
        
        viewModel.getEta { [weak self] minutesEta in
            guard let minutesEta = minutesEta,
                  let distance = self?.viewModel.distance else {return}
            self?.infoLabel.text = "\(minutesEta) • \(distance)"
        }
    }
    
}
