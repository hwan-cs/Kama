//
//  AppDelegate.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/01.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        GMSServices.provideAPIKey(K.GoogleMapsAPIKey)
        GMSPlacesClient.provideAPIKey(K.GoogleMapsAPIKey)
        return true
    }
}

