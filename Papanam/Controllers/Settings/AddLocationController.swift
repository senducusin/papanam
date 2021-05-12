//
//  AddLocationController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/12/21.
//

import UIKit
import MapKit

protocol AddLocationControllerDelegate: AnyObject {
    func updateLocation(locationString: String, viewModel: SettingsViewModel)
}

class AddLocationController: UITableViewController {
    // MARK: - Properties
    private let searchBar = UISearchBar()
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion](){
        didSet{
            print("DEBUG: reloaded?")
            tableView.reloadData()
        }
    }
    private let location: CLLocation
    private let settingsVm: SettingsViewModel
    
    weak var delegate: AddLocationControllerDelegate?
    
    // MARK: - Lifecycle
    init(vm: SettingsViewModel, location: CLLocation){
        self.settingsVm = vm
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchBar()
        setupSearchCompleter()
    }
    
    // MARK: - Helpers
    private func setupUI(){
        
    }
    
    private func setupTableView(){
        tableView.register(LocationInputCell.self, forCellReuseIdentifier: LocationInputCell.cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.addShadow()
    }
    
    private func setupSearchBar(){
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
    }
    
    private func setupSearchCompleter(){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        searchCompleter.region = region
        searchCompleter.delegate = self
    }
}

// MARK: - UITableView Delegate & DataSource
extension AddLocationController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationInputCell.cellIdentifier, for: indexPath) as! LocationInputCell
        
        cell.searchItem = searchResults[indexPath.row]
        cell.selectionStyle = .default
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let title = result.title
        let subtitle = result.subtitle
        var locationString = title + " " + subtitle
        locationString = locationString.replacingOccurrences(of: ", Philippines", with: "")
        
        delegate?.updateLocation(locationString: locationString, viewModel:settingsVm )
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchBar Delegate
extension AddLocationController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

// MARK: - MKLocalSearchCompleter Delegate
extension AddLocationController: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}
