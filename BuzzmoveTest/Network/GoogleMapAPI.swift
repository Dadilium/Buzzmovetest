//
//  GoogleMapAPI.swift
//  BuzzmoveTest
//
//  Created by Antoine ROY on 14/03/2018.
//  Copyright © 2018 Antoine ROY. All rights reserved.
//

import Alamofire

class GoogleMapAPI {
    static let shared = GoogleMapAPI() //Singleton pattern
    let netManager = NetworkReachabilityManager()!
    
    //searchPlace makes a GET request to a URL given as parameter, and run a callback function is the return if successful
    func searchPlace(param: String, callback: ((_ json: Any) -> Void)! = nil) {
        let escapedString = param.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print("https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(escapedString!)&key=\(APIKEY)")
        Alamofire.request("https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(escapedString!)&key=\(APIKEY)").responseJSON { response in
            print(response)
            if let json = response.result.value {
                print(json)
                callback?(json)
                
            }
        }
    }
    
    func isOnline() -> Bool {
        return netManager.isReachable
    }
}
