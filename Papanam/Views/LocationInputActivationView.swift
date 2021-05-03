//
//  LocationInputActivationView.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import UIKit

protocol LocationInputActivationViewDelegate: AnyObject {
    func presentLocationInputView()
}

class LocationInputActivationView: UIView {
    // MARK: - Properties
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    weak var delegate: LocationInputActivationViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
        setupTapGetsure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc private func viewTappedHandler(){
        delegate?.presentLocationInputView()
    }
    
    // MARK: - Helpers
    func setupUI(){
        backgroundColor = .white
        layer.cornerRadius = 10
        addShadow()
        
        setupIndicatorView()
        setupPlaceholderLabel()
    }
    
    func setupTapGetsure(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTappedHandler))
        addGestureRecognizer(tap)
    }

    func setupIndicatorView(){
        addSubview(indicatorView)
        indicatorView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        indicatorView.setDimensions(height: 6, width: 6)
    }
    
    func setupPlaceholderLabel(){
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self, leftAnchor: indicatorView.rightAnchor, paddingLeft: 20)
        
    }
}
