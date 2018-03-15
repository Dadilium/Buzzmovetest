//
//  Place.swift
//  BuzzmoveTest
//
//  Created by Antoine ROY on 14/03/2018.
//  Copyright © 2018 Antoine ROY. All rights reserved.
//

import ObjectMapper

class Place: Mappable {
    var results: [PlaceItem]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    //map the result of the API call to the object 'results'
    func mapping(map: Map) {
        results <- map["results"]
    }
}
