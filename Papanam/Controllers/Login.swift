//
//  Login.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

class Login:UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PAPANAM"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .white
        setupTitleLabel()
    }
    
    private func setupTitleLabel(){
        view.addSubview(titleLabel)
        let padding:CGFloat = 10
        titleLabel.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: padding, paddingRight: padding)
    }
}
