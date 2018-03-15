//
//  GoogleMapAPI.swift
//  BuzzmoveTest
//
//  Created by Antoine ROY on 14/03/2018.
//  Copyright © 2018 Antoine ROY. All rights reserved.
//

import Alamofire
import AlamofireImage

class GoogleMapAPI {
    static let shared = GoogleMapAPI() //Singleton pattern
    let netManager = NetworkReachabilityManager()!
    
    //searchPlace makes a GET request to a URL given as parameter, and run a callback function is the return if successful
    func searchPlace(param: String, callback: ((_ json: Any) -> Void)! = nil) {
        let escapedString = param.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        Alamofire.request("https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(escapedString!)&key=\(APIKEY)").responseJSON { response in
            if let json = response.result.value {
                callback?(json)
            }
        }
    }
    
    //call the google map API to download the image of the place
    func downloadImage(image: UIImageView, reference: String) {
        image.af_setImage(withURL: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=\(APIKEY)")!, placeholderImage: UIImage(named: "buzzmovePlaceholder"), filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: image.frame.size, radius: 5.0))
        image.sizeToFit()
    }
    
    //return if the device if connected to internet or not
    func isOnline() -> Bool {
        return netManager.isReachable
    }
}
