//
//  MapViewController.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/9/23.
//

import UIKit
import MapKit
import Combine
import SwiftUI
import CoreLocation

class MapViewController: UIViewController {
    weak var coordinator: MapCoordinator?

    private var isInitialAppearance : Bool = true
    private let coreLocation : CoreLocationManager? =
    (UIApplication.shared.delegate as? AppDelegate)?.locationManager
    private let mapViewModel : MapViewModel = MapViewModel()
    private var subscribers = Set<AnyCancellable>()
    private var zoomedState : String? = nil {
        didSet {
            updateViews()
            if oldValue != zoomedState {
            }
        }
    }
    private var altitude : CGFloat = .zero
    private var isValidAltitude : Bool {
        return altitude < 8000000
    }
    private var parksDictionary : [UUID:ParkViewModel] = [:]
    private let mapView : MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    private var seeAllButtonWidth : NSLayoutConstraint = NSLayoutConstraint()
    private let currentLocationButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.imageView?.clipsToBounds = true
        button.imageView?.tintColor = TrailityColor.dominantColor
        button.layer.cornerRadius = 30
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.tintColor = .lightText
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let detailViewtitle : UILabel = {
       let label = UILabel()
        label.text = "Zoom more to reload"
        label.font = .poppins(size : 16 , weight: .semiBold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dataLabelView : UIView = {
       let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .black
        uiView.layer.cornerRadius = 8
        uiView.layer.opacity = 0.6
        
        return uiView
    }()
    
    private let showAllButton = SeeAllButton()
    private let reloadButton = LoaderButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setUpBinding()
        layout()
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let coreLocation = coreLocation,
           coreLocation.isUserLocationAuthorized && isInitialAppearance {
            if let coordinates = coreLocation.locationManager.location?.coordinate {
                MapServices().centerMapOnLocation(coordinates, mapView: self.mapView)
                isInitialAppearance = false
            }
        }
    }
    
    private func setup() {
        // delegate
        self.mapView.delegate = self
        self.mapView.showsUserLocation = coreLocation?.isUserLocationAuthorized ?? false
                    
        // subviews
        self.view.addSubview(mapView)
        self.view.addSubview(currentLocationButton)
        self.view.addSubview(showAllButton)
        self.view.addSubview(reloadButton)
        self.dataLabelView.addSubview(detailViewtitle)
        self.view.addSubview(dataLabelView)
        
        showAllButton.onSelection = showAllOnSelectionBinding
        reloadButton.onTap = reloadButtonBinding
        currentLocationButton.addTarget(self, action: #selector(currentLocationTapped), for: .touchUpInside)
        }
    
    private func layout() {
        let safeArea = view.safeAreaLayoutGuide
        seeAllButtonWidth = showAllButton.widthAnchor.constraint(equalToConstant: 150)
        NSLayoutConstraint.activate(
        [
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            reloadButton.bottomAnchor.constraint(equalTo: showAllButton.topAnchor, constant: -10),
            reloadButton.leadingAnchor.constraint(equalTo: self.showAllButton.leadingAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: 150),
            reloadButton.heightAnchor.constraint(equalToConstant: 50),
//
            showAllButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -25),
            showAllButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            showAllButton.widthAnchor.constraint(equalToConstant: 150),
            showAllButton.heightAnchor.constraint(equalToConstant: 50),
            
            currentLocationButton.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),
            currentLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 60),
            currentLocationButton.widthAnchor.constraint(equalTo: currentLocationButton.heightAnchor),
            
            dataLabelView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            dataLabelView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dataLabelView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            dataLabelView.heightAnchor.constraint(equalToConstant: 50),
            
            detailViewtitle.topAnchor.constraint(equalTo: dataLabelView.topAnchor, constant: 10),
            detailViewtitle.leadingAnchor.constraint(equalTo: dataLabelView.leadingAnchor, constant: 10),
            detailViewtitle.trailingAnchor.constraint(equalTo: dataLabelView.trailingAnchor, constant: -10),
            detailViewtitle.bottomAnchor.constraint(equalTo: dataLabelView.bottomAnchor, constant: -10)
        ])
        
    }
    
    private func setUpBinding() {
        mapViewModel
            .$parks
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self]  parks in
                guard let self = self else { return }
                self.parksDictionary = parks
                self.addAnnotations()
            })
            .store(in: &subscribers)
        
        mapViewModel
            .$isLoading
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self]  isLoading in
                guard let self = self else { return }
                self.showAllButton.isLoading = isLoading
                self.reloadButton.isLoading = isLoading
                
            })
            .store(in: &subscribers)
    }
    
    
}

//MARK: - Functions
extension MapViewController {
    
    private func updateViews() {
        let shouldHideReloadButton : Bool = self.showAllButton.isSelected || self.zoomedState == nil || !isValidAltitude
        self.reloadButton.isHidden = shouldHideReloadButton
        if self.showAllButton.isSelected {
            self.dataLabelView.isHidden = true
        } else if shouldHideReloadButton {
            self.dataLabelView.isHidden = false
            self.detailViewtitle.text = "Zoom more to reload"
        }
        else if let state = zoomedState {
            self.detailViewtitle.text = state
            self.dataLabelView.isHidden = false
        }
                
    }
        
    private func addAnnotations(){
        hideAllAnnotations()
        for park in self.parksDictionary.values{
            if let annotation = park.mapAnnotation {
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    private func hideAllAnnotations() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
    
    
    private func makeRequest() {
        if let state = self.zoomedState {
            mapViewModel.searchParks(for: state)
        }
    }
    
    private func showAllOnSelectionBinding() {
        weak var _self = self
        _self?.updateViews()
        if let _self = _self {
            if _self.showAllButton.isSelected {
                _self.mapViewModel.searchAllParks()
            } else { _self.mapViewModel.resetParks()}
        }
    }
    
    private func reloadButtonBinding() {
        weak var _self = self
        if let _self = _self {
            if let state = _self.zoomedState {
                _self.mapViewModel.searchParks(for: state)
            }
        }
    }
    
    @objc
    private func currentLocationTapped() {
        guard let coreLocation = coreLocation else { return }
        if !coreLocation.isUserLocationAuthorized {
            coordinator?.showAlertFalure()
            return
        }
        if let coordinates = coreLocation.locationManager.location?.coordinate {
            MapServices().centerMapOnLocation(coordinates, mapView: self.mapView)
        }
    }
    
}

//MARK: - MKMapViewDelegate
extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ParkAnnotation{
            let image = UIImage(named: AssetImageName.nps)
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            view.image = image
            view.isEnabled = true
            view.canShowCallout = true
            view.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            view.contentMode = .scaleAspectFit
            configureDetailView(annotationView: view, annotation: annotation)

            return view
        }
        return nil
    }
    
    
    func configureDetailView(annotationView: MKAnnotationView, annotation : ParkAnnotation) {
        let calloutWidth = UIScreen.screenWidth * 0.8
        let calloutView = CalloutDetailView(id: annotation.id)
        calloutView.delegate = self
        calloutView.translatesAutoresizingMaskIntoConstraints = false

        let views = ["calloutView": calloutView]

        calloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[calloutView(\(calloutWidth))]", options: [], metrics: nil, views: views))
        calloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[calloutView(60)]", options: [], metrics: nil, views: views))
        
        annotationView.detailCalloutAccessoryView = calloutView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let callout = view.detailCalloutAccessoryView as? CalloutDetailView {
            if let annotation = mapView.selectedAnnotations.last as? ParkAnnotation {
                callout.configureCallout(annotation: annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        altitude = mapView.camera.centerCoordinateDistance
        if !isValidAltitude {
            zoomedState = nil
            return
        }
        guard let center = MapServices().getCenterLocation(for: mapView) else {return}
        
        MapServices().reverseGeoCoder(center: center) { [weak self] placeMark in
            defer {self?.updateViews()}
            guard let placeMark = placeMark else { return }
            self?.zoomedState = placeMark.administrativeArea

        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    }
}

//MARK: - CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
}


//MARK: - CalloutDelegate
extension MapViewController : CalloutDelegate {
    func calloutTapped(id: UUID) {
        if let park = parksDictionary[id] {
            coordinator?.goToDetail(park)
        }
    }
}

//MARK: - UIGestureRecognizerDelegate
extension MapViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return coordinator?.hasElments() ?? false
    }

    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
