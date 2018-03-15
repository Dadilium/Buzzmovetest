//
//  PlaceDetailViewController.swift
//  BuzzmoveTest
//
//  Created by Antoine ROY on 15/03/2018.
//  Copyright © 2018 Antoine ROY. All rights reserved.
//

import UIKit
import AlamofireImage

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    var placeDetail: PlaceItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init the content of the detail page
        if let place = placeDetail {
            placeImage.af_setImage(withURL: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(place.photo ?? "")&key=\(APIKEY)")!, placeholderImage: UIImage(named: "buzzmovePlaceholder"), filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: placeImage.frame.size, radius: 5.0))
            placeAddress.numberOfLines = 0
            placeAddress.text = (place.formatted_address ?? "").replacingOccurrences(of: ", ", with: "\n")
            placeName.text = place.name ?? ""
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Action to perform the unwind segue
    @IBAction func backToMap(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMap", sender: nil)
    }
}
