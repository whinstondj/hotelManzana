//
//  AddRegistrationTableViewController.swift
//  hotelManzana
//
//  Created by Winston Castillo on 6/6/18.
//  Copyright © 2018 Winston Castillo. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkInDateField: UIDatePicker!
    @IBOutlet weak var checkOutDateField: UIDatePicker!
    let checkInDateFieldCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateFieldCellIndexPath = IndexPath(row: 3, section: 1)
    @IBOutlet weak var numberOfNigths: UILabel!
    @IBOutlet weak var roomTypePriceTotal: UILabel!
    @IBOutlet weak var WiFiTotal: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var totalServiceLabel: UILabel!
    
    var totalPrice = 0
    var numberOfNIghtsTotal = 0
    var roomTypePrice = 0
    var roomType: RoomType?
    var totalPriceWifi = 0
    
    var registration: Registration? {
        guard let roomType = roomType else { return nil }
        let fName = firstName.text ?? ""
        let lName = lastName.text ?? ""
        let email = emailAdress.text ?? ""
        let checkInDate = checkInDateField.date
        let checkOutDate = checkOutDateField.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstName: fName, lastName: lName, emailAdress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, roomType: roomType, wifi: hasWifi)
    }

    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        checkWifiValue()
        updateDateViews()
        updatePPrices()
    }

    func checkWifiValue () {
        if wifiSwitch.isOn {
            totalPriceWifi = numberOfNIghtsTotal * 10
            WiFiTotal.text = "Y     " + String(totalPriceWifi) + " $"
        } else {
            WiFiTotal.text = "N     0 $"
            totalPriceWifi = 0
        }
    }

    func updatePPrices () {
        totalPrice = roomTypePrice + totalPriceWifi
        totalServiceLabel.text = String(totalPrice) + " $"
    }
    
    func didSelect (roomType:RoomType) {
        self.roomType = roomType
        updateRoomType ()
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
            roomTypePrice = roomType.price * numberOfNIghtsTotal
            roomTypePriceTotal.text = roomType.shortName + "     " + String (roomTypePrice) + " $"
            updatePPrices()
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateNUmberOfGuests()
    }
    
    var isCheckInDateFieldShown: Bool = false {
        didSet {
            checkInDateField.isHidden = !isCheckInDateFieldShown
        }
    }

    var isCheckOutDateFieldShown: Bool = false {
        didSet {
            checkOutDateField.isHidden = !isCheckOutDateFieldShown
        }
    }

    func updateNUmberOfGuests () {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
/*
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        var registration:Registration? {
            
            guard let roomType = roomType else { return nil }
            let fName = firstName.text ?? ""
            let lName = lastName.text ?? ""
            let email = emailAdress.text ?? ""
            let checkInDate = checkInDateField.date
            let checkOutDate = checkOutDateField.date
            let numberOfAdults = Int(numberOfAdultsStepper.value)
            let numberOfChildren = Int(numberOfChildrenStepper.value)
            let hasWifi = wifiSwitch.isOn
            
            return Registration(firstName: fName, lastName: lName, emailAdress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, roomType: roomType, wifi: hasWifi)
            }
        
    }
  */
    
    func updateDateViews () {
        checkOutDateField.minimumDate = checkInDateField.date.addingTimeInterval(86400)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDateField.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDateField.date)
        let totalDays = Calendar.current.dateComponents([.day], from: checkInDateField.date, to: checkOutDateField.date)
        numberOfNIghtsTotal = (Int(totalDays.day!) + 1)
        numberOfNigths.text = String(numberOfNIghtsTotal)
        updatePPrices()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (checkInDateFieldCellIndexPath.section, checkInDateFieldCellIndexPath.row):
            if isCheckInDateFieldShown {
                return 216.0
            } else {
                return 0.0
            }
        case (checkOutDateFieldCellIndexPath.section, checkOutDateFieldCellIndexPath.row):
            if isCheckOutDateFieldShown {
                return 216.0
            } else {
                return 0.0
            }
        default:
            return 44.0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDateField.minimumDate = midnightToday
        checkOutDateField.date = midnightToday
        updateNUmberOfGuests()
        updateRoomType()
        updateDateViews()
        checkWifiValue()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (checkInDateFieldCellIndexPath.section, checkInDateFieldCellIndexPath.row - 1):
            if isCheckInDateFieldShown {
                isCheckInDateFieldShown = false
            } else if isCheckOutDateFieldShown {
                isCheckOutDateFieldShown = false
                isCheckInDateFieldShown = true
            } else {
                isCheckInDateFieldShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (checkOutDateFieldCellIndexPath.section, checkOutDateFieldCellIndexPath.row - 1):
            if isCheckOutDateFieldShown {
                isCheckOutDateFieldShown = false
            } else if isCheckInDateFieldShown {
                isCheckInDateFieldShown = false
                isCheckOutDateFieldShown = true
            } else {
                isCheckOutDateFieldShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()

        default:
            break
        }
    }
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? SelectRoomTypeTableViewController
        destinationViewController?.delegate = self
        destinationViewController?.roomType = roomType
    }

}
