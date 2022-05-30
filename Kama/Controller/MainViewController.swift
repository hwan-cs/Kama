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
import SwiftDate

class MainViewController: UIViewController
{
    
    @IBOutlet var mapView: GMSMapView!
    
    let db = Firestore.firestore()
    
    var locationManager: CLLocationManager?
    
    var user: KamaUser?
    
    var dateUUID = [Date: String]()
    
    var markers = [GMSMarker]()
    
    var timer = Timer()
    
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

        loadMap()
        

        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
            self.checkDate
            { result in
                if (result != "")
                {
                    self.loadMap(result)
                }
            }
        })
        
        
        if user!.disabled == true
        {
            let helpButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2-125, y: UIScreen.main.bounds.height-110, width: 250, height: 75))
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
    
    func loadMap(_ uuidToDelete: String = "")
    {
        db.collection("kamaDB").whereField("title", isNotEqualTo: false).getDocuments
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
                        if uuidToDelete == data["uuid"] as! String
                        {
                            doc.reference.delete()
                            {   err in
                                if let err = err
                                {
                                    print("Error removing document as owner: \(err)")
                                }
                                else
                                {
                                    for m in self.markers
                                    {
                                        if m.userData as! String == uuidToDelete
                                        {
                                            m.map = nil
                                        }
                                    }
                                    print("Document successfully removed!")
                                }
                            }
                        }
                        if let geopoint = data["location"] as? GeoPoint
                        {
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
                            marker.title = data["title"] as! String
                            marker.userData = data["uuid"] as! String
                            print(data["title"] as! String)
                            if !self.markers.contains(marker)
                            {
                                self.markers.append(marker)
                            }
                            marker.snippet = data["description"] as? String ?? "도와주세요"
                            marker.map = self.mapView
                            self.dateUUID.updateValue(data["uuid"] as! String, forKey: (data["time"] as! Timestamp).dateValue())
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
    
    @objc func helpButtonTapped()
    {
        print("help button tapped")
        let vc = HelpViewController()
        vc.user = self.user
        vc.onDismissBlock = { result in
            self.loadMap()
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }

    func checkDate(completion: (String) -> ()) -> String
    {
        print("checkdate")
        let currentDate = Date()
        for (date, uuid) in dateUUID
        {
            if (date.compare(toDate: currentDate, granularity: .minute) == .orderedAscending)
            {
                self.dateUUID.removeValue(forKey: date)
                print("Im going to remove \(uuid) at \(date)")
                completion(uuid)
                return uuid
            }
        }
        completion("")
        return ""
    }
}
//
extension MainViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {

    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        if let uuid = marker.userData as? String
        {
            db.collection("kamaDB").whereField("title", isNotEqualTo: false).getDocuments
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
                            let fsuuid = data["uuid"] as! String
                            if fsuuid == uuid
                            {
                                let help = KamaHelp(category: data["category"] as? String ?? "요청 세부사항이 없습니다", description: data["description"] as? String ?? "", location: data["location"] as! GeoPoint, title: data["title"] as! String, time: data["time"] as! Timestamp, userName: data["userName"] as! String, uuid: data["uuid"] as! String, requestedBy: data["requestedBy"] as! String, requestAccepted: data["requestAccepted"] as! Bool)
                                let vc = DetailViewController()
                                vc.help = help
                                vc.user = self.user
                                vc.modalPresentationStyle = .overCurrentContext
                                self.present(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
        return true
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


