//
//  USer.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/30.
//

import Foundation

struct KamaUser
{
    var name: String
    var disabled: Bool
    var id: String
    var points: Int?
    init(name: String, disabled: Bool, id: String)
    {
        self.name = name
        self.disabled = disabled
        self.id = id
    }
}
