//
//  HomeController.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import UIKit
import MapKit

protocol HomeControllerDelegate:AnyObject {
    func handleMenuToggle()
}

class HomeController:UIViewController {
    // MARK: - Properties
    weak var delegate: HomeControllerDelegate?
    
    private let mapView = MKMapView()
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private lazy var rideActionView = RideActionView(user: viewModel.user)
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
    
    lazy var viewModel = HomeViewModel(homeView: view)
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationService.shared.didStartMonitor = { manager, region in
            print("DEBUG: region identifier \(region.identifier)")
            if region.identifier == AnnotationType.pickup.rawValue {
                print("DEBUG: Did start monitoring pickup region \(region)")
            }else if region.identifier == AnnotationType.destination.rawValue {
                print("DEBUG: Did start monitoring destination region \(region)")
            }
        }
        
        LocationService.shared.didEnterRegion = { manager, region in
            guard let trip = self.viewModel.trip else {return}
            
            if region.identifier == AnnotationType.pickup.rawValue {
                DriverService.shared.updateTripState(trip: trip, state: .driverArrived) { [weak self] error, ref in
                    self?.rideActionView.viewModel.config = .pickupPassenger
                }
            }else if region.identifier == AnnotationType.destination.rawValue {
                DriverService.shared.updateTripState(trip: trip, state: .arrivedAtDestination) { [weak self] error, ref in
                    self?.rideActionView.viewModel.config = .endTrip
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        guard viewModel.needsToReconfigure else {return}
        
        if viewModel.shouldSetupUI() {
            self.configure()
        }
        
        if !viewModel.appStarted {
            
            viewModel.userDidSet = { [weak self] user in
                
                self?.tableView.reloadData()
                
                guard let vm = self?.viewModel.needsToReconfigure,
                      vm,
                      let userOld = self?.viewModel.oldUser else {return}
                
                self?.reconfigure(userOld: userOld, user: user)
            }
            
            viewModel.appStarted.toggle()
        }
    }
    
    // MARK: - API
    
    private func startTrip(){
        guard let trip = viewModel.trip else {return}
        DriverService.shared.updateTripState(trip: trip, state: .inProgress) { [weak self] error, ref in
            self?.rideActionView.viewModel.config = .tripInProgress
            self?.removePlacemarkAnnotationAndOverlays()
            self?.mapView.addAnnotationAndSelect(forCoordinate: trip.destination.coordinate)
            
            let placemark = MKPlacemark(coordinate: trip.destination.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            
            self?.setCustomRegion(withType: .destination, coordinates: trip.destination.coordinate)
            self?.generatePolyline(toDestination: mapItem)
            
            guard let annotations = self?.mapView.annotations else {return}
            self?.mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    private func fetchAndConfigurePassengerWithUid(_ uid: String, config:RideActionConfiguration){
        
        PassengerService.shared.fetchUserDataWith(uid: uid) { [weak self] result in
            switch result {
            
            case .success(let user):
                
                self?.rideActionView.viewModel.passenger = user
                self?.rideActionView.viewModel.config = config
                self?.shouldPresentRideActionView(true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchAndConfigureDriverWithUid(_ uid: String, config:RideActionConfiguration){
        
        PassengerService.shared.fetchUserDataWith(uid: uid) { [weak self] result in
            switch result {
            
            case .success(let user):
                
                self?.rideActionView.viewModel.driver = user
                self?.rideActionView.viewModel.config = config
                self?.shouldPresentRideActionView(true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func observeCancelledTrip(_ trip:Trip){
        DriverService.shared.observeCancelledTrip(trip) {
            self.viewModel.trip = nil
            self.dismissRideSessionUI()
            self.presentAlertController(withTitle: "Oops!", withMessage: "The passenger has cancelled this trip. Press OK to continue")
        }
    }
    
    private func observeAddedTrips(){
        DriverService.shared.observeAddedTrips { [weak self] trip in
            guard let trip = trip,
                  trip.state == .requested else {return}
            
            self?.viewModel.trip = trip
            self?.showPickupController(trip: trip)
        }
    }
    
    private func fetchDrivers(){
        PassengerService.shared.fetchDrivers { [weak self] result in
            switch result {
            case .success(let user):
                self?.setupDriver(user: user)
            //                self?.showAnnotationsInCurrentTrip()
            case .failure(let error):
                print("DEBUG: \(error)")
            }
        }
    }
    
    private func uploadTrip(_ trip:Trip){
        let animationDuration = viewModel.animationDuration
        let frameHeight = self.view.frame.height
        
        PassengerService.shared.uploadTrip(trip) { [weak self] error, ref in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            UIView.animate(withDuration: animationDuration) {
                self?.rideActionView.frame.origin.y = frameHeight
            }
        }
    }
    
    private func cancelTripHandler(usingActionButton:Bool){
        PassengerService.shared.deleteTrip { [weak self] error, ref in
            if let error = error {
                print(error.localizedDescription)
                
                if usingActionButton {
                    self?.viewModel.trip = nil
                    self?.dismissRideSessionUI()
                }
                
                return
            }
            self?.viewModel.trip = nil
            self?.dismissRideSessionUI()
        }
    }
    
    private func observeCurrentTrip(){
        PassengerService.shared.observeCurrentTrip { [weak self] trip in
            guard let trip = trip else {
                return
            }
            
            self?.viewModel.trip = trip
            if trip.state == .accepted {
                self?.shouldPresentLoadingView(false)
                self?.removePlacemarkAnnotationAndOverlays()
                self?.showAnnotationsInCurrentTrip(withDriverUid: trip.driverUid)
                self?.presentRideActionView(withConfig: .tripAccepted)
                
            }else if trip.state == .driverArrived {
                self?.rideActionView.viewModel.config = .driverArrived
                
            }else if trip.state == .inProgress {
                self?.rideActionView.viewModel.config = .tripInProgress
                
            }else if trip.state == .arrivedAtDestination {
                self?.rideActionView.viewModel.config = .endTrip
                
            }else if trip.state == .completed {
                
                PassengerService.shared.deleteTrip { [weak self] error, ref in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    self?.shouldPresentRideActionView(false)
                    self?.centerMapOnUserLocation()
                    self?.inputActivationView.alpha = 1
                    self?.updateActionButtonConfig(.showMenu)
                    self?.presentAlertController(withTitle: "Trip Completed", withMessage: "PAPANAM hope you enjoyed your trip!")
                }
            }
        }
    }
    
    // MARK: - Selectors
    @objc private func actionHandler(){
        switch viewModel.actionButtonConfig {
        case .showMenu :
            delegate?.handleMenuToggle()
        case .dismissActionView:
            cancelTripHandler(usingActionButton: true)
        }
    }
    
    // MARK: - Helpers
    private func reconfigure(userOld:User, user:User){
        mapView.removeAnnotations(mapView.annotations)
        if mapView.overlays.count > 0 {
            mapView.removeOverlay(mapView.overlays[0])
        }
        
        DriverService.shared.removeAllObservers(uid: userOld.uid)
        PassengerService.shared.removeAllObservers(uid: userOld.uid)
        
        rideActionView.setUser(user)
        
        if user.type == .passenger {
            animateInputActivationView()
            locationInputView.user = user
            fetchDrivers()
            observeCurrentTrip()
            
        }else{
            UIView.animate(withDuration: 0.5) {
                self.inputActivationView.alpha = 0
            }
            
            observeAddedTrips()
        }
    }
    
    private func showAnnotationsInCurrentTrip(withDriverUid uid:String?) {
        
        guard let uid = uid else {return}
        
        var annotations = [MKAnnotation]()
        self.mapView.annotations.forEach({ annotation in
            if let driverAnno = annotation as? DriverAnnotation {
                if driverAnno.uid == uid {
                    annotations.append(driverAnno)
                }
            }
            
            if let userAnno = annotation as? MKUserLocation {
                annotations.append(userAnno)
            }
        })
        
        self.mapView.showAnnotations(annotations, animated: true)
    }
    
    private func showPickupController(trip:Trip){
        let controller = PickupController(trip: trip)
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func shouldPresentRideActionView(_ present:Bool){
        UIView.animate(withDuration: viewModel.animationDuration) {
            self.rideActionView.frame.origin.y = self.viewModel.getRideActionViewOriginY(present: present)
        }
    }
    
    private func configureDestination(_ placemark:MKPlacemark){
        mapView.addAnnotationAndSelect(forCoordinate: placemark.coordinate)
        
        let destination = MKMapItem(placemark: placemark)
        generatePolyline(toDestination: destination)
        
        focusToRegionOfAnnotations()
        presentRideActionView(withPlacemark: placemark)
    }
    
    private func presentRideActionView(withPlacemark placemark:MKPlacemark){
        rideActionView.viewModel.placemark = placemark
        rideActionView.viewModel.config = .requestRide
        shouldPresentRideActionView(true)
    }
    
    private func presentRideActionView(withConfig config:RideActionConfiguration){
        
        guard let trip = viewModel.trip else {return}
        
        if config == .tripAccepted {
            if  viewModel.user?.type == .driver {
                guard let uid = trip.passengerUid else {return}
                self.fetchAndConfigurePassengerWithUid(uid, config: config)
            } else if viewModel.user?.type == .passenger {
                guard let uid = trip.driverUid else {return}
                self.fetchAndConfigureDriverWithUid(uid, config: config)
            }
        }else{
            rideActionView.viewModel.config = config
            shouldPresentRideActionView(true)
        }
    }
    
    private func configure(){
        guard let user = viewModel.user else {return}
        
        setupUI()
        LocationService.shared.enableLocationServices()
        
        if user.type == .passenger {
            locationInputView.user = user
            fetchDrivers()
            observeCurrentTrip()
            setupSavedUserLocations()
        }else if user.type == .driver{
            observeAddedTrips()
        }
    }
    
    private func clearTrip(){
        if viewModel.trip != nil {
            rideActionView.viewModel.config = .requestRide
            viewModel.trip = nil
        }
    }
    
    private func dismissRideSessionUI(){
        
        removePlacemarkAnnotationAndOverlays()
        UIView.animate(withDuration: viewModel.animationDuration) {
            
            if self.viewModel.user?.type == .passenger {
                self.inputActivationView.alpha = 1
                self.updateActionButtonConfig(.showMenu)
            }
            
            if self.viewModel.user?.type == .driver {
                self.centerMapOnUserLocation()
            }else{
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
            
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
        //        guard viewModel.user?.type == .passenger else {return}
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
        
        if viewModel.user?.type == .passenger {
            animateInputActivationView()
        }
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
    
    private func setupSavedUserLocations(){
        
        viewModel.savedLocations.removeAll()
        
        if let homeLocation = viewModel.user?.homeLocation {
            geocodeAddressString(address: homeLocation)
        }
        
        if let workLocation = viewModel.user?.workLocation {
            geocodeAddressString(address: workLocation)
        }
    }
    
    private func geocodeAddressString(address: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            
            print("DEBUG: will convert placemark \(placemarks) : \(address)")
            
            guard let clPlacemark = placemarks?.first else {return}
            
            let placemark = MKPlacemark(placemark: clPlacemark)
            
            print("DEBUG: \(address) - \(placemark)")
            
            self?.viewModel.savedLocations.append(placemark)
            self?.tableView.reloadData()
        }
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ?
//            viewModel.numberOfRowsForSavedLocations :
//            viewModel.numberOfRowsForSearchResult
        
        return viewModel.numberOfRowsForSearchResult
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationInputCell.cellIdentifier, for: indexPath) as! LocationInputCell
        
//        if indexPath.section == 1 {
            cell.placemark = viewModel.searchResultPlacemarkAt(index: indexPath.row)
//        }else{
//            cell.placemark = viewModel.savedLocationPlacemarkAt(index: indexPath.row)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = viewModel.searchResultPlacemarkAt(index: indexPath.row)
        
        updateActionButtonConfig(.dismissActionView)
        
        dismissLocationView { [weak self] _ in
            self?.configureDestination(destination)
        }
    }
}

// MARK: - MKMapViewDelegate Delegate & Helpers
extension HomeController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let userType = viewModel.user?.type,
              userType == .driver,
              let location = userLocation.location else {return}
        
        DriverService.shared.updateDriverLocation(location: location)
    }
    
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
        
        if driver.uid == viewModel.trip?.driverUid {
            showAnnotationsInCurrentTrip(withDriverUid: driver.uid)
        }
        
    }
    
    private func centerMapOnUserLocation(){
        guard let coordinate = LocationService.shared.location?.coordinate else {return}
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
    
    private func focusToRegionOfAnnotations(){
        let annotations = mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
        
        mapView.showAnnotations(annotations, animated: true)
    }
    
    private func setCustomRegion(withType type:AnnotationType, coordinates: CLLocationCoordinate2D){
        let region = CLCircularRegion(center: coordinates, radius: 25, identifier: type.rawValue)
        LocationService.shared.locationManager.startMonitoring(for: region)
    }
    
}

// MARK: - RideActionView Delegate & Helpers
extension HomeController: RideActionViewDelegate {
    func dropOffPassenger() {
        guard let trip = viewModel.trip else {return}
        
        DriverService.shared.updateTripState(trip: trip, state: .completed) { [weak self] error, ref in
            self?.removePlacemarkAnnotationAndOverlays()
            self?.centerMapOnUserLocation()
            self?.shouldPresentRideActionView(false)
        }
    }
    
    func pickupPassenger() {
        startTrip()
    }
    
    func cancelTrip() {
        cancelTripHandler(usingActionButton: false)
    }
    
    func getDirections() {
        
    }
    
    func uploadTrip(_ view: RideActionView) {
        uploadTripHandler(view)
    }
    
    private func uploadTripHandler(_ view: RideActionView){
        guard let user = viewModel.user,
              let destinationCoordinates = view.viewModel.placemark?.coordinate,
              let destinationAddress = view.viewModel.placemark?.address,
              let destinationName = view.viewModel.placemark?.name,
              let pickupCoordinates = LocationService.shared.location?.coordinate
        else {
            return}
        
        let destination = Place(coordinate: destinationCoordinates, address: destinationAddress, name: destinationName)
        
        pickupCoordinates.getAddress { [weak self] pickup in
            
            guard let pickup = pickup else {return}
            
            self?.shouldPresentLoadingView(true, message: "Finding you a ride...")
            
            let trip = Trip(passengerUid: user.uid, destination: destination, pickup: pickup)
            
            self?.uploadTrip(trip)
        }
    }
    
}

// MARK: - PickupControllerDelegate & Helpers
extension HomeController: PickupControllerDelegate {
    func didAcceptTrip(_ controller: PickupController, trip: Trip) {
        viewModel.trip = trip
        viewModel.trip?.state = .accepted
        mapView.addAnnotationAndSelect(forCoordinate: trip.pickup.coordinate)
        
        let placemark = MKPlacemark(coordinate: trip.pickup.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        generatePolyline(toDestination: mapItem)
        
        setCustomRegion(withType: .pickup, coordinates: trip.pickup.coordinate)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        controller.dismiss(animated: true) {
            self.presentRideActionView(withConfig: .tripAccepted)
            self.observeCancelledTrip(trip)
        }
    }
}


// MARK: - Public Methods
extension HomeController {
    public func setNewUser(_ user: User){
        viewModel.oldUser = viewModel.user
        viewModel.user = user
    }
}
