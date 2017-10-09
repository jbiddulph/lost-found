//
//  NewEventViewController.swift
//  WorthingTown
//
//  Created by John Biddulph on 01/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class NewEventViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MKMapViewDelegate {
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    var circleRenderer = MKCircleRenderer()
    var dbRef:DatabaseReference!
    var dbRef1:DatabaseReference!
    var addedBy = String()
    let manager = CLLocationManager()
    var sweets = [Sweet]()
    var centermap = ""
    var areasize = 100
    var mapLatitude = CGFloat()
    var mapLonitude = CGFloat()
    var itemmapLatitude = CGFloat()
    var itemmapLonitude = CGFloat()
    var foundlostHeader = String()
    var city = String()
    var thelocationName = String()
    
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var eventName: UITextField!
    @IBOutlet var eventVenue: UITextField!
    @IBOutlet var eventDate: UITextField!
    @IBOutlet var eventTime: UITextField!
    @IBOutlet var eventCategory: UITextField!
    @IBOutlet var eventPrice: UITextField!
    @IBOutlet var eventStatus: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var TargetGridReference: UILabel!
    @IBOutlet var mapZoomControl: UISwitch!
    @IBOutlet var headerTitle: UILabel!
    
    @IBAction func zoomControlSwitch(_ sender: Any) {
        if(mapZoomControl.isOn){
            self.mapView.isZoomEnabled = false
            let alert = UIAlertController(title: "Zoom Locked", message: "This is locked by default to show the area in which the item was lost, by default this is set to 100 meter radius", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.mapView.isZoomEnabled = true
            let alert = UIAlertController(title: "Warning!", message: "Unlocking map zoom is for interaction purposes only, location will be set to center of circle", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
        
    @IBAction func textFieldEditing(_ sender: Any) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        eventDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(NewEventViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func timeFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .time
        eventTime.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(NewEventViewController.timePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd MMM yyyy"
        eventDate.text = dateFormatter.string(from: sender.date)
        
    }
    func timePickerValueChanged(sender: UIDatePicker) {
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.none
        timeFormatter.timeStyle = DateFormatter.Style.medium
        timeFormatter.dateFormat = "HH:mm"
        eventTime.text = timeFormatter.string(from: sender.date)
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.image = UIImage(named: "foust")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileImageView)
        setupProfileImageView()
        mapView.delegate = self
        manager.delegate = self
        self.mapView.isZoomEnabled = false
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.hideKeyboardWhenTappedAround()
        dbRef = Database.database().reference().child("events-list").child("worthing-events-list")
        dbRef1 = Database.database().reference().child("sweet-items")
        // Do any additional setup after loading the view.
        pickerSelector()
        headerTitle.text = foundlostHeader
        self.title = foundlostHeader
        //circle movement
        let circleView = UIView()
        eventPrice.text = thelocationName
        if(foundlostHeader == "Lost") {
            eventStatus.text = "Lost"
            circleView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        } else if(foundlostHeader == "Found") {
            eventStatus.text = "Found"
            circleView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        }
        mapView.addSubview(circleView)
        mapView.bringSubview(toFront: circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(areasize))
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(areasize))
        let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
        
        let mapcentrelat = mapView.bounds.size.width
        let mapcenterlon = mapView.bounds.size.height
        print("map Lat Long centered: \(mapcentrelat) and \(mapcenterlon)")
        
        view.updateConstraints()
        UIView.animate(withDuration: 1.0, animations: {
            self.mapView.layoutIfNeeded()
            circleView.layer.cornerRadius = circleView.frame.width/2
            circleView.clipsToBounds = true
            //let centrelat = self.mapView.centerXAnchor
            //let centerlon = self.mapView.centerYAnchor
            //print("Lat Long centered: \(centrelat) and \(centerlon)")
        })
        
        
        let mylat = manager.location?.coordinate.latitude
        let mylon = manager.location?.coordinate.longitude
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        
        mapLatitude = itemmapLatitude
        mapLonitude = itemmapLonitude
        let latAndLong = "Lat: \(mapLatitude) Long: \(mapLonitude)"
        
        self.TargetGridReference.text = latAndLong
    }
    
    
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let location = locations[0] as CLLocation
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            let placeMarks = data as! [CLPlacemark]
            let loc: CLPlacemark = placeMarks[0]
            
            self.mapView.centerCoordinate = location.coordinate
            let addr = loc.locality
            //self.address.text = addr
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 750, 750)
            self.mapView.setRegion(reg, animated: true)
            self.mapView.showsUserLocation = true
            
            guard let addressDict = placeMarks[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
            }
            
            // Access each element manually
            if let locationName = addressDict["Name"] as? String {
                print(locationName)
            }
            if let street = addressDict["Thoroughfare"] as? String {
                print(street)
            }
            if let city = addressDict["City"] as? String {
                print(city)
            }
            if let zip = addressDict["ZIP"] as? String {
                print(zip)
            }
            if let country = addressDict["Country"] as? String {
                print(country)
            }
            
            
        })
        // We use a predefined location
        var centerlocation = CLLocation(latitude: manager.location?.coordinate.latitude as! CLLocationDegrees, longitude: manager.location?.coordinate.longitude as! CLLocationDegrees)
        
    }
    
    
    @IBAction func addVenue(_ sender: Any) {
        let ref1 = Database.database().reference()
        
        ref1.child("towns").queryOrdered(byChild: "townName").queryEqual(toValue: "Worthing").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var townCheck = snapshot.value
            if ((townCheck) != nil){
                print("exists!")
            } else {
                self.addLocation()
            }
        });
        
        createnewEvent()
        
        //Dont really need it ... yet
        //addItemChat()
        let alert = UIAlertController(title: "Added!", message: "Thank you for listing the item you found. Hopefully someone will claim it soon.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        //let nextViewController = storyBoard.instantiateViewController(withIdentifier: "getEvents") as! UICollectionViewController
        //self.present(nextViewController, animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerSelector(){
        
        dbRef1.observe(DataEventType.value, with: { (snapshot:DataSnapshot) in
            var newSweets = [Sweet]()
            
            
            for sweet in snapshot.children.allObjects{
                let sweetObject = Sweet(snapshot: sweet as! DataSnapshot)
                newSweets.append(sweetObject)
            }
            self.picker.delegate = self
            self.picker.dataSource = self
            
            self.sweets = newSweets
        })
        
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     // return sweets[row]
     
     }*/
    // The number of rows of data
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sweets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //bigLabel.text = venues[row].rsPubName
        eventVenue.text = sweets[row].key
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sweets[row].content
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
