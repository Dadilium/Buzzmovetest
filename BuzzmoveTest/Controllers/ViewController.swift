//
//  ViewController.swift
//  BuzzmoveTest
//
//  Created by Antoine ROY on 14/03/2018.
//  Copyright © 2018 Antoine ROY. All rights reserved.
//

import UIKit
import GooglePlaces
import ObjectMapper
import AlamofireImage
import MapKit

class ViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.map.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if !GoogleMapAPI.shared.isOnline() {
            print("no internet")
            Cache.shared.retrieveCache()
            tableView.reloadData()
            displayListAnnotationsFromPlace(list: Cache.shared.places)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func runSearch() {
        guard let str = self.searchBar.text else { return }
        GoogleMapAPI.shared.searchPlace(param: str, callback: { json in
            if let places = Mapper<Place>().map(JSON: json as! [String: Any]), let results = places.results {
                self.map.removeAnnotations(self.map.annotations)
                self.displayListAnnotationsFromPlace(list: results)
                Cache.shared.saveCache(cache: results)
                self.tableView.reloadData()
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let place = getPlaceFromAnnotation(annotation: view.annotation as! MKPointAnnotation) {
            place.toString()
            self.map.setCenter(CLLocationCoordinate2D(latitude: place.latitude!, longitude: place.longitude!), animated: true)
            performSegue(withIdentifier: "ShowDetail", sender: place)
        }
        //segue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail", let place = sender as? PlaceItem {
            place.toString()
            let destination = segue.destination as! PlaceDetailViewController
            destination.placeDetail = place
        }
    }
    
    func getPlaceFromAnnotation(annotation: MKPointAnnotation) -> PlaceItem? {
        for place in Cache.shared.places {
            if let ann = place.annotation, ann == annotation {
                return place
            }
        }
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        runSearch()
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cache.shared.places.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceIdentifier", for: indexPath) as! PlaceTableViewCell
        let place = Cache.shared.places[indexPath.row]
        
        cell.placeImage.af_setImage(withURL: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(place.photo ?? "")&key=\(APIKEY)")!, placeholderImage: UIImage(named: "buzzmovePlaceholder"), filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: cell.placeImage.frame.size, radius: 5.0))
        cell.placeImage.sizeToFit()
        cell.placeAddress.text = place.formatted_address ?? ""
        cell.placeAddress.adjustsFontSizeToFitWidth = true
        cell.placeAddress.numberOfLines = 2
        cell.placeAddress.minimumScaleFactor = 0.6
        cell.placeName.text = place.name ?? ""
        cell.placeTypes.text = (place.types ?? []).map({"\($0.replacingOccurrences(of: "_", with: " "))"}).joined(separator: ", ")
        return cell
    }
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {}

    func displayListAnnotationsFromPlace(list: [PlaceItem]) {
        for place in list {
            if let lat = place.latitude, let lng = place.longitude, let name = place.name {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                annotation.title = name
                place.annotation = annotation
                self.map.addAnnotation(annotation)
            }
        }
        self.map.showAnnotations(self.map.annotations, animated: true)
    }
}

