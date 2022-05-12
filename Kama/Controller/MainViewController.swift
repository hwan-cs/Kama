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
import Firebase
import FirebaseFirestore

class MainViewController: UIViewController
{

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    
    let db = Firestore.firestore()
    
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
        db.collection("kamaDB").whereField("name", isNotEqualTo: false).getDocuments
        { querySnapShot, error in
            if let e = error
            {
                print("There was an issue retrieving data from Firestore \(e)")
            }
            else
            {
                if let snapshotDocuments = querySnapShot?.documents
                {
                    for doc in snapshotDocuments
                    {
                        let data = doc.data()
                        if let geopoint = data["location"] as? GeoPoint
                        {
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
                            marker.title = data["name"] as! String
                            print(data["name"] as! String)
                            marker.map = self.mapView
                        }
                    }
                }
            }
        }
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
//            print("new location is \(location)")
        }
    }

}


