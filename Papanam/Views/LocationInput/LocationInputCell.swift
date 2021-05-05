//
//  LocationInputCell.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/4/21.
//

import UIKit
import MapKit

class LocationInputCell: UITableViewCell {
    // MARK: - Properties
    static let cellIdentifier = "LocationInputCell"
    
    var placemark: MKPlacemark? {
        didSet {
            configure()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI(){
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 17)
    }
    
    private func configure(){
        titleLabel.text = placemark?.name
        addressLabel.text = placemark?.address
    }
}
