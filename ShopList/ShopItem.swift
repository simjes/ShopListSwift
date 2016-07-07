//
//  ShopItem.swift
//  ShopList
//
//  Created by Simon on 07/07/16.
//  Copyright © 2016 simjes. All rights reserved.
//

import Foundation
import RealmSwift

class ShopItem: Object {
    dynamic var itemName = ""
    dynamic var itemType = ""
    dynamic var timeOfInsert = NSDate()

// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
