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
        
        //set all delegates
        searchBar.delegate = self
        self.map.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        //if user is not connected to internet, retrieve the saved cache and display it
        if !GoogleMapAPI.shared.isOnline() {
            Cache.shared.retrieveCache()
            tableView.reloadData()
            displayListAnnotationsFromPlace(list: Cache.shared.places)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //launch the API call to get all places accorded to the search bar text
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
    
    //catch the click on a Annotation pin on the map and perform the segue to the second controller
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let place = getPlaceFromAnnotation(annotation: view.annotation as! MKPointAnnotation) {
            self.map.setCenter(CLLocationCoordinate2D(latitude: place.latitude!, longitude: place.longitude!), animated: true)
            performSegue(withIdentifier: "ShowDetail", sender: place)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail", let place = sender as? PlaceItem {
            let destination = segue.destination as! PlaceDetailViewController
            destination.placeDetail = place
        }
    }
    
    //get the object PlaceItem according to the address of the annotation clicked on the map.
    func getPlaceFromAnnotation(annotation: MKPointAnnotation) -> PlaceItem? {
        for place in Cache.shared.places {
            if let ann = place.annotation, ann == annotation {
                return place
            }
        }
        return nil
    }
    
    //when the field lose focus, then the research is launch
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
        
        GoogleMapAPI.shared.downloadImage(image: cell.placeImage, reference: place.photo ?? "")
        cell.placeAddress.text = place.formatted_address ?? ""
        cell.placeName.text = place.name ?? ""
        cell.placeTypes.text = (place.types ?? []).map({"\($0.replacingOccurrences(of: "_", with: " "))"}).joined(separator: ", ")
        
        return cell
    }
    
    //catch the unwind segue from the PlaceDetailController
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {}

    //print all the annotations from list into the map
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

