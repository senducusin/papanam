//
//  SettingsController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/11/21.
//

import UIKit

class SettingsController: UITableViewController {
    // MARK: - Properties
    private let user :User
    
    private lazy var infoHeader: UserInfoHeader = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        let view = UserInfoHeader(frame: frame)
        
        return view
    }()
    
    // MARK: - Lifecycle
    init(user:User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    // MARK: - Selectors
    @objc func handleDismiss(){
        
    }
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .gray
        
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.cancelWithTint, style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func setupTableView(){
        tableView.rowHeight = 60
        tableView.register(LocationInputCell.self, forCellReuseIdentifier: LocationInputCell.cellIdentifier)
        tableView.backgroundColor = .white
        infoHeader.user = self.user
        tableView.tableHeaderView = infoHeader
    }
    
}
