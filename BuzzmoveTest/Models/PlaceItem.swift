//
//  PlaceItem.swift
//  BuzzmoveTest
//
//  Created by Antoine ROY on 14/03/2018.
//  Copyright © 2018 Antoine ROY. All rights reserved.
//

import ObjectMapper
import MapKit

class PlaceItem: NSObject, NSCoding, Mappable {

    var formatted_address: String?
    var latitude: Double?
    var longitude: Double?
    var icon: String?
    var id: String?
    var name: String?
    var photo: String?
    var types: [String]?
    var annotation: MKPointAnnotation?
    let unset: String = "Value not set"
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    //decode all the necessary variables for the offline manipulations
    required init(coder aDecoder: NSCoder) {
        self.formatted_address = aDecoder.decodeObject(forKey: "formatted_address") as? String ?? ""
        self.latitude = aDecoder.decodeDouble(forKey: "latitude")
        self.longitude = aDecoder.decodeDouble(forKey: "longitude")
        self.icon = aDecoder.decodeObject(forKey: "icon") as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.photo = aDecoder.decodeObject(forKey: "photo") as? String ?? ""
    }
    
    //encode all the necessary variables for the offline manipulations
    func encode(with aCoder: NSCoder) {
        aCoder.encode(formatted_address, forKey: "formatted_address")
        aCoder.encode(latitude!, forKey: "latitude")
        aCoder.encode(longitude!, forKey: "longitude")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(photo, forKey: "photo")
    }
    
    //map each place of the API request into separated variables
    func mapping(map: Map) {
        formatted_address <- map["formatted_address"]
        latitude <- map["geometry.location.lat"]
        longitude <- map["geometry.location.lng"]
        icon <- map["icon"]
        id <- map["id"]
        name <- map["name"]
        photo <- map["photos.0.photo_reference"]
        types <- map["types"]
    }
    
    func toString() {
        print("PlaceItem: ")
        print("formatted_address: \(formatted_address ?? unset)")
        print("latitude: \(latitude ?? 0.0)")
        print("longitude: \(longitude ?? 0.0)")
        print("icon: \(icon ?? unset)")
        print("id: \(id ?? unset)")
        print("name: \(name ?? unset)")
        print("photo: \(photo ?? unset)")
        print("types: \(types ?? [])")
    }
}
