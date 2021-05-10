//
//  MenuHeader.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/10/21.
//

import UIKit

class MenuHeader: UIView {
    // MARK: - Properties
    
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
    private func setupUI(){
        backgroundColor = .themeBlack
    }
}
