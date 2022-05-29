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
    var name: String
    var time: Timestamp
    var user: String
    var uuid: String
    init(category: String, description: String, location: GeoPoint, name: String, time: Timestamp, user:String, uuid: String)
    {
        self.category = category
        self.description = description
        self.location = location
        self.name = name
        self.time = time
        self.user = user
        self.uuid = uuid
    }
    
    init(category: String, location: GeoPoint, name: String, time: Timestamp, user:String, uuid: String)
    {
        self.category = category
        self.location = location
        self.name = name
        self.time = time
        self.user = user
        self.uuid = uuid
    }
}
