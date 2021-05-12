//
//  ContainerController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/10/21.
//

import UIKit

class ContainerController: UIViewController {
    // MARK: - Properties
    private let homeController = HomeController()
    private let menuController = MenuController()
    private lazy var blackView:UIView = {
        let view = UIView()
        view.frame = view.bounds
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
        return view
    }()
    private lazy var viewModel = ContainerViewModel(view: view)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AuthService.shared.activeUser == nil {
            DispatchQueue.main.async {
                self.showLoginView()
            }
        }else{
            fetchUser()
        }
    }
    
    // MARK: - Selectors
    @objc private func dismissMenuHandler(){
        toggleMenu()
    }
    
    // MARK: - API
    private func fetchUser(){
        if let activeUid = AuthService.shared.activeUser {
            PassengerService.shared.fetchUserDataWith(uid: activeUid) { [weak self] result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.viewModel.user = user
                        
                        if self?.viewModel.appStarted == false {
                            self?.setupHomeController(user: user)
                            self?.setupMenuController(user: user)
                            self?.setupBlackView()
                            self?.viewModel.appStarted.toggle()
                        }else{
                            self?.homeController.setNewUser(user)
                            self?.menuController.user = user
                        }
                    }
                    
                case .failure(let error):
                    print("DEBUG: ? \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func signout(){
        AuthService.shared.signOut { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.showLoginView()
        }
    }
    
    // MARK: - Helpers
    private func setupBlackView() {
        view.addSubview(blackView)
        blackView.frame = CGRect(x: self.view.frame.width - 80, y: 0, width: 80, height: view.frame.height)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenuHandler))
        blackView.addGestureRecognizer(tap)
    }
    
    private func setupHomeController(user:User){
        addChild(homeController)
        homeController.viewModel.user = user
        homeController.didMove(toParent: self)
        
        view.addSubview(homeController.view)
        homeController.delegate = self
    }
    
    private func setupMenuController(user:User){
        addChild(menuController)
        menuController.didMove(toParent: self)
        view.insertSubview(menuController.view, at: 0)
        menuController.user = user
        menuController.delegate = self
    }
    
    private func showLoginView(){
        let nav = UINavigationController(rootViewController: LoginController())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func toggleMenu(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations:{
            
            self.homeController.view.frame.origin.x = self.viewModel.frameOrigin()
            
                self.blackView.alpha = self.viewModel.blackViewAlpha
                self.blackView.frame.origin.x = self.viewModel.blackViewOriginX

        },completion: nil)
    }
}



// MARK HomeController Delegate
extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle() {
        
        if !viewModel.toggled {
            menuController.view.alpha = 1
        }
        
        toggleMenu()
    }
}

// MARK MenuController Delegate
extension ContainerController: MenuControllerDelegate {
    func didSelect(option: MenuOptionsViewModel) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations:{
            
            self.homeController.view.frame.origin.x = self.viewModel.frameOrigin()
            self.blackView.alpha = self.viewModel.blackViewAlpha
            self.blackView.frame.origin.x = self.viewModel.blackViewOriginX
            
        }) { [weak self] _ in
            switch option {
            
            case .yourTrips:
                break
            case .settings:
                self?.presentSettings()
            case .logout:
                self?.presentLogoutAlert()
            }
        }
    }
    
    private func presentSettings(){
        guard let user = viewModel.user else {return}
        let controller = SettingsController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barStyle = .black
        nav.navigationBar.barTintColor = .themeBlack
        
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func presentLogoutAlert(){
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        
        alert.addAction((UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.signout()
        })))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
