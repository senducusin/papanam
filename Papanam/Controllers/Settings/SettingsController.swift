//
//  SettingsController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/11/21.
//

import UIKit

class SettingsController: UITableViewController {
    // MARK: - Properties
    private var user :User
    
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
        self.dismiss(animated: true, completion: nil)
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
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        tableView.tableFooterView = UIView()
    }
    
    private func locationText(forType vm:SettingsViewModel) -> String{
        switch vm {
        
        case .home:
            return user.homeLocation ?? vm.subtitle
        case .work:
            return user.workLocation ?? vm.subtitle
        }
    }
    
}

// MARK: - UITableView Delegate & DataSource
extension SettingsController{
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .themeBlack
        
        let title = UILabel()
        title.font = .systemFont(ofSize: 16)
        title.textColor = .white
        title.text = "Favorites"
        
        view.addSubview(title)
        title.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 16)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationInputCell.cellIdentifier) as! LocationInputCell
        
        let viewModel = SettingsViewModel(rawValue: indexPath.row)
        let value = viewModel == .home ? user.homeLocation : user.workLocation
        cell.setupSettingsCell(withViewModel: viewModel, value:value )
        cell.selectionStyle = .default
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewModel = SettingsViewModel(rawValue: indexPath.row),
              let location = LocationService.shared.location else {return}
        
        let controller = AddLocationController(vm: viewModel, location:location)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
        
    }
}

// MARK: - AddLocationController Delegate
extension SettingsController: AddLocationControllerDelegate {
    func updateLocation(locationString: String, viewModel: SettingsViewModel) {
        PassengerService.shared.saveLocation(locationString: locationString, vm: viewModel) { [weak self] error, ref in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            switch viewModel {
            case .home:
                self?.user.homeLocation = locationString
            case .work:
                self?.user.workLocation = locationString
            }
            
            self?.tableView.reloadData()
        }
    }
}
