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
    var category: String
    var description: String?
    var location: GeoPoint
    var title: String
    var time: Timestamp
    var userName: String
    var uuid: String
    var requestedBy: String
    var requestAccepted: Bool
    
    init(category: String, description: String, location: GeoPoint, title: String, time: Timestamp, userName:String, uuid: String, requestedBy: String, requestAccepted: Bool)
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
    }
}
