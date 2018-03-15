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

    //local save of the last research
    var places: [PlaceItem] = []
    
    //save the content into UserDefault after encoding
    func saveCache(cache: [PlaceItem]) {
        self.places = cache
        let encode = NSKeyedArchiver.archivedData(withRootObject: self.places)
        UserDefaults.standard.set(encode, forKey: "cachePlaces")
        
    }
    
    //retrieve the content saved back to the local variable
    func retrieveCache() {
        if let encode = UserDefaults.standard.data(forKey: "cachePlaces") {
            if let decPlaces = NSKeyedUnarchiver.unarchiveObject(with: encode) as? [PlaceItem] {
                self.places = decPlaces
            }
        }
    }
}
