//
//  MainViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/09.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MainViewController: UIViewController
{

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        
        if let location = locationManager?.location
        {
            let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 17.0)
            mapView.camera = camera
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        locationManager?.stopUpdatingLocation()
    }
}

extension MainViewController: GMSMapViewDelegate
{
    
}

extension MainViewController: CLLocationManagerDelegate
{
    //MARK: - CLLocationManager Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse
        {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            print("new location is \(location)")
        }
        
//        let marker = GMSMarker()
//        marker.position = location!.coordinate
//        marker.title = "사용자"
//        marker.map = mapView
    }

}


