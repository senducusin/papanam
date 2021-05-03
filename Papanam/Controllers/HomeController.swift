//
//  HomeController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import UIKit
import MapKit

class HomeController:UIViewController {
    // MARK: - Properties
    private let mapView = MKMapView()
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    
    private let locationManager = CLLocationManager()
    
    private var viewModel = HomeViewModel()
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !AuthService.isUserLoggedIn() {
            showLoginView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.shouldSetupUI() {
            setupUI()
            enableLocationServices()
        }
    }
    
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .white
        
        setupMapView()
        setupInputActivationView()
        animateInputActivationView()
    }
    
    private func setupMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    

    
    private func setupInputActivationView(){
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
    }
    
    private func animateInputActivationView(){
        UIView.animate(withDuration: 1.5) {
            self.inputActivationView.alpha = 1
        }
    }
}

// MARK: - Auth Service Helper
extension HomeController {
    private func showLoginView(){
        let nav = UINavigationController(rootViewController: LoginController())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    private func signoutHandler(){
        AuthService.signOut { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.showLoginView()
        }
    }
}

// MARK: - Location Service Delegate & Helpers
extension HomeController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setupLocationManager()
        }
    }
    
    private func enableLocationServices(){
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
//        case .authorizedWhenInUse:
//            setupLocationManager()
        default:
            break
        }
    }
    
    private func setupLocationManager(){
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}

// MARK: - LocationInputActivationView Delegate & Helpers
extension HomeController: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        inputActivationView.alpha = 0
        setupLocationInputView()
        animateLocationInputView()
    }

    private func setupLocationInputView(){
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
        locationInputView.alpha = 0
        locationInputView.delegate = self
    }
    
    private func animateLocationInputView(){
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            print("DEBUG: present tableview")
        }
    }
}

// MARK: - LocationInputView Delegate & Helpers
extension HomeController: LocationInputViewDelegate{
    func dismissLocationInputView() {
        UIView.animate(withDuration: 0.3) {
            self.locationInputView.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }
    }
}
