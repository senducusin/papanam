//
//  HomeController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import UIKit
import MapKit

class HomeController:UIViewController {
    // MARK: - Properties
    private let mapView = MKMapView()
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let rideActionView = RideActionView()
    private let tableView = UITableView()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage.menuImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        button.addTarget(self, action: #selector(actionHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var viewModel = HomeViewModel(homeView: view)
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()

//        signout()

        if AuthService.shared.activeUser == nil {
            DispatchQueue.main.async {
                self.showLoginView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let activeUid = AuthService.shared.activeUser, viewModel.shouldSetupUI() {
            // == Add a preloader here ==
            fetchCurrentUserData(uid: activeUid)
        }
        
    }
    
    // MARK: - API
    private func observeTrips(){
        FirebaseService.shared.observeTrips { [weak self] trip in
            guard let trip = trip else {return}
            
            self?.viewModel.trip = trip
            self?.showPickupController(trip: trip)
        }
    }
    
    private func fetchDrivers(){
        guard viewModel.user?.type == .passenger else {return}
        
        FirebaseService.shared.fetchDrivers { [weak self] result in
            switch result {
            case .success(let user):
                self?.setupDriver(user: user)
            case .failure(let error):
                print("DEBUG: \(error)")
            }
        }
    }
    
    private func fetchCurrentUserData(uid:String){
        FirebaseService.shared.fetchUserDataWith(uid: uid) { [weak self] result in
            switch result {
            case .success(let user):
                self?.configure(user: user)
            case .failure(let error):
                print("DEBUG: ? \(error.localizedDescription)")
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
    
    // MARK: - Selectors
    @objc private func actionHandler(){
        switch viewModel.actionButtonConfig {
        case .showMenu :
//            AuthService.shared.signOut { error in
//                print(error?.localizedDescription)
//            }
            break;
        case .dismissActionView:
            self.dismissRideSession()
        }
    }
    
    // MARK: - Helpers
    private func showPickupController(trip:Trip){
        let controller = PickupController(trip: trip)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    private func shouldPresentRideActionView(_ present:Bool){
        UIView.animate(withDuration: viewModel.animationDuration) {
            self.rideActionView.frame.origin.y = self.viewModel.getRideActionViewOriginY(present: present)
        }
    }
    
    private func configureDestination(_ placemark:MKPlacemark){
        addAnnotationWithSelectedPlacemark(placemark)
        
        let destination = MKMapItem(placemark: placemark)
        generatePolyline(toDestination: destination)
        
        focusToRegionOfAnnotations()
        presentRideActionView(withPlacemark: placemark)
    }
    
    private func presentRideActionView(withPlacemark placemark:MKPlacemark){
        rideActionView.placemark = placemark
        shouldPresentRideActionView(true)
    }
    
    private func configure(user:User){
        viewModel.user = user
        setupUI()
        LocationService.shared.enableLocationServices()
        
        if user.type == .passenger {
            locationInputView.user = user
            fetchDrivers()
        }else if user.type == .driver{
            observeTrips()
        }
    }
    
    private func dismissRideSession(){
        removePlacemarkAnnotationAndOverlays()
        UIView.animate(withDuration: viewModel.animationDuration) {
            self.inputActivationView.alpha = 1
            self.updateActionButtonConfig(.showMenu)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            self.shouldPresentRideActionView(false)
        }
    }
  
    private func updateActionButtonConfig(_ actionConfig: ActionButtonConfiguration){
        viewModel.actionButtonConfig = actionConfig
        actionButton.setImage(actionConfig.buttonImage, for: .normal)
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        setupMapView()
        setupActionButton()
        setupUiForPassenger()
        setupRideActionView()
    }
    
    private func setupUiForPassenger(){
        guard viewModel.user?.type == .passenger else {return}
        setupInputActivationView()
        setupTableView()
    }
    
    private func setupMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    private func setupInputActivationView(){
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: viewModel.inputActivationViewWidth)
        inputActivationView.anchor(top:actionButton.bottomAnchor, paddingTop: 16)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        animateInputActivationView()
    }
    
    private func setupActionButton(){
        view.addSubview(actionButton)
        actionButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,  paddingTop: 16, paddingLeft: 16, width: 40, height: 33)
    }
    
    private func setupRideActionView(){
        view.addSubview(rideActionView)
        rideActionView.frame = CGRect(x: 0, y: viewModel.rideActionViewStartingOriginY, width: viewModel.rideActionViewWidth, height: viewModel.rideActionViewHeight)
        rideActionView.delegate = self
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationInputCell.self, forCellReuseIdentifier: LocationInputCell.cellIdentifier)
        
        tableView.rowHeight = 60
        tableView.keyboardDismissMode = .onDrag
        
        tableView.frame = CGRect(x: 0, y: viewModel.tableViewStartingOriginY, width: viewModel.tableViewWidth, height: viewModel.tableViewHeight)
        
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
    private func animateInputActivationView(){
        UIView.animate(withDuration: 1.5) {
            self.inputActivationView.alpha = 1
        }
    }
}

// MARK: - Auth Service Helper
extension HomeController {
    private func showLoginView(){
        let nav = UINavigationController(rootViewController: LoginController())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - LocationInputActivationView Delegate & Helpers
extension HomeController: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        inputActivationView.alpha = 0
        setupLocationInputView()
        animateLocationInputView()
    }
    
    private func setupLocationInputView(){
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: viewModel.locationInputViewHeight)
        locationInputView.alpha = 0
        locationInputView.delegate = self
    }
    
    private func animateLocationInputView(){
        UIView.animate(withDuration: viewModel.animationDuration) {
            self.locationInputView.alpha = 1
        } completion: { [weak self] _ in
            guard let newHeight = self?.viewModel.locationInputViewHeight,
                  let animationDuration = self?.viewModel.animationDuration else {return}
            UIView.animate(withDuration: animationDuration) {
                self?.tableView.frame.origin.y = newHeight
            }
        }
    }
}

// MARK: - LocationInputView Delegate & Helpers
extension HomeController: LocationInputViewDelegate{
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { [weak self] placemarks in
            self?.viewModel.searchResults = placemarks
            self?.tableView.reloadData()
        }
    }
    
    func dismissLocationInputView() {
        let animationDuration = viewModel.animationDuration
        
        dismissLocationView { [weak self] _ in
            UIView.animate(withDuration: animationDuration) {
                self?.inputActivationView.alpha = 1
            }
        }
    }
    
    private func dismissLocationView(completion: ((Bool)->())? = nil ){
        
        UIView.animate(withDuration: viewModel.animationDuration, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.viewModel.tableViewStartingOriginY
            self.locationInputView.removeFromSuperview()
            
        }, completion:completion)
    }
    
    private func searchBy(naturalLanguageQuery: String, completion:@escaping([MKPlacemark])->()){
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {return}
            response.mapItems.forEach { mapItem in
                results.append(mapItem.placemark)
            }
            completion(results)
        }
    }
}

// MARK: - TableView Delegate, Datasource, and Helpers
extension HomeController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : viewModel.numberOfRowsForSearchResult
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationInputCell.cellIdentifier, for: indexPath) as! LocationInputCell
        
        if indexPath.section == 1 {
            cell.placemark = viewModel.placemarkAt(index: indexPath.row)
        }else{
            cell.placemark = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = viewModel.placemarkAt(index: indexPath.row)
        
        updateActionButtonConfig(.dismissActionView)
        
        dismissLocationView { [weak self] _ in
            self?.configureDestination(destination)
        }
    }
}

// MARK: - MKMapViewDelegate Delegate & Helpers
extension HomeController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: MKAnnotationView.driverAnnotationIdentifier)
            view.image = UIImage.driverAnnotation
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = self.viewModel.route {
            let polyline = route.polyline
            let lineRenderer = MKPolylineRenderer(overlay: polyline)
            lineRenderer.strokeColor = .black
            lineRenderer.lineWidth = 3
            return lineRenderer
        }
        return MKOverlayRenderer()
    }
    
    private func generatePolyline(toDestination destination:MKMapItem){
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let directionRequest = MKDirections(request: request)
        directionRequest.calculate { [weak self] response, error in
            guard let response = response,
                  error == nil else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            self?.viewModel.route = response.routes[0]
            guard let polyline = self?.viewModel.route?.polyline else {return}
            self?.mapView.addOverlay(polyline)
            
        }
    }
    
    private func addAnnotationWithSelectedPlacemark(_ placemark:MKPlacemark){
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    private func removePlacemarkAnnotationAndOverlays(){
        mapView.annotations.forEach { annotation in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
        
        if mapView.overlays.count > 0 {
            mapView.removeOverlay(mapView.overlays[0])
        }
        
    }
    
    private func setupDriver(user driver: User){
        guard let coordinate = driver.location?.coordinate else {return}
        
        if let existingDriverAnnotation = viewModel.driverIsVisible(mapView: mapView, user: driver) {
            
            existingDriverAnnotation.updateAnnotationPosition(withCoordinate: coordinate)
            
        }else{
            let annotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func focusToRegionOfAnnotations(){
        let annotations = mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
        
        mapView.showAnnotations(annotations, animated: true)
    }
    
}

// MARK: - RideActionView Delegate
extension HomeController: RideActionViewDelegate {
    func uploadTrip(_ view: RideActionView) {
        guard let pickupCoordinates = LocationService.shared.location?.coordinate,
              let destinationCoordinates = view.placemark?.coordinate,
              let address = view.placemark?.address,
              let title = view.placemark?.name,
              let trip = Trip(title: title, address: address, pickupCoordinates: pickupCoordinates, destinationCoordinates: destinationCoordinates)
               else {return}
        
        FirebaseService.shared.uploadTrip(trip) { error, ref in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("DEBUG did upload trip successfully")
        }
    }
}
