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
    private lazy var viewModel = ContainerViewModel(view: view)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHomeController()
        setupMenuController()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func setupHomeController(){
        addChild(homeController)
        homeController.didMove(toParent: self)
        
        view.addSubview(homeController.view)
        homeController.delegate = self
    }
    
    private func setupMenuController(){
        addChild(menuController)
        menuController.didMove(toParent: self)
        view.insertSubview(menuController.view, at: 0)
    }
}

extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle() {
        
        if !viewModel.toggled {
            menuController.view.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations:{
            self.homeController.view.frame.origin.x = self.viewModel.frameOrigin()
        }, completion: nil)
    }
}
