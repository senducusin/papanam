//
//  MenuController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/10/21.
//

import UIKit

class MenuController: UIViewController {
    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.tableHeaderView = menuHeader
        return tableView
    }()
    
    private lazy var viewModel =  MenuViewModel(view: view)
    
    private lazy var menuHeader: MenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: viewModel.frameWidth, height: viewModel.headerFrameHeight)
        
        let view = MenuHeader(frame: frame)
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    private func setupUI(){
        view.backgroundColor = .white
        view.alpha = 0
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test"
        return cell
    }
}
