//
//  CityTableViewController.swift
//  iwanta
//
//  Created by Meg Sandman on 6/23/15.
//  Copyright (c) 2015 Meg Sandman. All rights reserved.
//

import UIKit

class CityTableViewController: UITableViewController {
    
    var citiesArray = [City]()
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        self.parentViewController?.view.addSubview(spinner)
        spinner.startAnimating()
        
        getCities()
        tableView.rowHeight = 201
    }
    
    func getCities() {
        //        var urlString = "http://localhost:3000/cities"
        var urlString = "https://i-wanna.herokuapp.com/cities"
        
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                let errorMessage = error.localizedDescription
                let errorAlert = UIAlertView(title:"Error", message:error.localizedDescription as String, delegate:nil,
                    cancelButtonTitle:"OK")
                errorAlert.show()
                return
            }
            self.citiesArray = self.parseJsonData(data)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                if self.spinner.isAnimating() {
                    self.spinner.stopAnimating()
                }
            })
        })
        task.resume()
    }
    
    func parseJsonData(data: NSData) -> [City] {
        var error:NSError?
        var cities: [City] = []
        
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
        
        // Return nil if there are any errors
        if error != nil {
            println(error?.localizedDescription)
        }
        
        // Parse JSON data
        var jsonProducts = jsonResult as! [AnyObject]
        for jsonProduct in jsonProducts {
            
            var city = City(
                name: jsonProduct["name"] as! String,
                image: jsonProduct["image"] as! String
            )
            city.id = jsonProduct["id"] as! Int

            cities.append(city)
        }
        return cities
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.citiesArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        let urlString = citiesArray[indexPath.row].image
        let imgURL = NSURL(string: urlString)
        
        cell.nameLabel.text = citiesArray[indexPath.row].name
        cell.cityImageView.image = UIImage(named: "black")
        cell.cityImageView.setImageWithURL(imgURL!)
        cell.cityImageView.contentMode = .ScaleAspectFill
        cell.cityImageView.clipsToBounds = true
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showSelectionView") {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let newCont = segue.destinationViewController as! FormViewController
                newCont.city = citiesArray[indexPath.row]

            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
