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
    private let tableView = UITableView()
    
    private lazy var viewModel = HomeViewModel(homeView: view)
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !AuthService.shared.isUserLoggedIn() {
            DispatchQueue.main.async {
                self.showLoginView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.shouldSetupUI() {
            // == Add a preloader here ==
            AuthService.shared.fetchUserDataWith { [weak self] result in
                switch result {
                case .success(let user):
                    self?.configure(user: user)
//                    AuthService.shared.signOut { error in
//                        print(error?.localizedDescription)
//                    }
                    print("DEBUG: \(LocationService.shared.location)")
                case .failure(let error):
                    print("DEBUG: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func configure(user:User){
        viewModel.user = user
        locationInputView.user = user
        setupUI()
        LocationService.shared.enableLocationServices()
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        setupMapView()
        setupInputActivationView()
        animateInputActivationView()
        setupTableView()
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
        inputActivationView.setDimensions(height: 50, width: viewModel.inputActivationViewWidth)
        inputActivationView.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationInputCell.self, forCellReuseIdentifier: LocationInputCell.cellIdentifier)
        
        tableView.rowHeight = 60
        
        tableView.frame = CGRect(x: 0, y: viewModel.tableViewStartingOriginY, width: viewModel.tableViewWidth, height: viewModel.tableViewHeight)
        
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
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
        AuthService.shared.signOut { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.showLoginView()
        }
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
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: viewModel.locationInputViewHeight)
        locationInputView.alpha = 0
        locationInputView.delegate = self
    }
    
    private func animateLocationInputView(){
        UIView.animate(withDuration: viewModel.animationDuration) {
            self.locationInputView.alpha = 1
        } completion: { [weak self] _ in
            guard let newHeight = self?.viewModel.locationInputViewHeight,
                  let animationDuration = self?.viewModel.animationDuration else {return}
            UIView.animate(withDuration: animationDuration) {
                self?.tableView.frame.origin.y = newHeight
            }
        }
    }
}

// MARK: - LocationInputView Delegate & Helpers
extension HomeController: LocationInputViewDelegate{
    func dismissLocationInputView() {
        
        UIView.animate(withDuration: viewModel.animationDuration) {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.viewModel.tableViewStartingOriginY
        } completion: { [weak self] _ in
            self?.locationInputView.removeFromSuperview()
            
            guard let animationDuration = self?.viewModel.animationDuration else {return}
            UIView.animate(withDuration:animationDuration) {
                self?.inputActivationView.alpha = 1
            }
        }
    }
}

// MARK: - TableView Delegate, Datasource, and Helpers
extension HomeController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationInputCell.cellIdentifier, for: indexPath) as! LocationInputCell
        
        return cell
    }
    
}
