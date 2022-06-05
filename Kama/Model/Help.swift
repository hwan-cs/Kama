//
//  Help.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/30.
//

import Foundation
import FirebaseFirestore

struct KamaHelp
{
    let category: String
    var description: String?
    var location: GeoPoint
    let title: String
    let time: Timestamp
    let userName: String
    let uuid: String
    let requestedBy: String
    let requestAccepted: Bool
    var acceptedBy: String?
    let point: Int
    
    init(category: String, description: String, location: GeoPoint, title: String, time: Timestamp, userName:String, uuid: String, requestedBy: String, requestAccepted: Bool, acceptedBy: String, point: Int)
    {
        self.category = category
        self.description = description
        self.location = location
        self.title = title
        self.time = time
        self.userName = userName
        self.uuid = uuid
        self.requestAccepted = requestAccepted
        self.requestedBy = requestedBy
        self.acceptedBy = acceptedBy
        self.point = point
    }
    
    init(category: String, point: Int, userName: String, requestAccepted: Bool, title: String)
    {
        self.category = category
        self.point = point
        self.userName = userName
        self.requestAccepted = requestAccepted
        self.title = title
        
        self.location = GeoPoint(latitude: 0, longitude: 0)
        self.time = Timestamp()
        self.uuid = ""
        self.requestedBy = ""
    }
}
