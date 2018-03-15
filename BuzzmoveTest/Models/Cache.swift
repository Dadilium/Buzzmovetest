//
//  Cache.swift
//  BuzzmoveTest
//
//  Created by Antoine ROY on 14/03/2018.
//  Copyright © 2018 Antoine ROY. All rights reserved.
//

import Foundation

class Cache {
    static let shared = Cache() //Singleton pattern

    var places: [PlaceItem] = []
    
    func saveCache(cache: [PlaceItem]) {
        self.places = cache
        let encode = NSKeyedArchiver.archivedData(withRootObject: self.places)
        UserDefaults.standard.set(encode, forKey: "cachedPlaces2")
        
    }
    
    func retrieveCache() {
        let encode = UserDefaults.standard.data(forKey: "cachedPlaces2")
        if let encode = encode {
            let decPlaces = NSKeyedUnarchiver.unarchiveObject(with: encode) as? [PlaceItem]
            if let decPlaces = decPlaces {
                self.places = decPlaces
            }
        }
    }
}
