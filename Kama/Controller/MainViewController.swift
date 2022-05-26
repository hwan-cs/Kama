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
    
    @IBOutlet var mapView: GMSMapView!
    
    let db = Firestore.firestore()
    
    var locationManager: CLLocationManager?
    
    var isHelper: Bool?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.92, alpha: 1.00)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        
        if let location = locationManager?.location
        {
            let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 17.0)
            mapView.camera = camera
        }

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
        
        if isHelper == false
        {
            let helpButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2-147, y: UIScreen.main.bounds.height-110, width: 294, height: 75))
            helpButton.setTitle("도와주세요!", for: .normal)
            helpButton.setTitleColor(.black, for: .normal)
            helpButton.backgroundColor = UIColor(red: 0.83, green: 0.89, blue: 0.80, alpha: 1.00)
            helpButton.layer.cornerRadius = 37.5
            helpButton.layer.shadowColor = UIColor.black.cgColor
            helpButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            helpButton.layer.shadowOpacity = 0.7
            helpButton.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)
            view.addSubview(helpButton)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        locationManager?.stopUpdatingLocation()
    }
    
    @objc func helpButtonTapped()
    {
        print("help button tapped")
        let vc = HelpViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

extension MainViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        print("did tap \(marker.title)")
    }
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


