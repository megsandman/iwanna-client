//
//  FormViewController.swift
//  iwanta
//
//  Created by Meg Sandman on 6/18/15.
//  Copyright (c) 2015 Meg Sandman. All rights reserved.
//

import UIKit
import MessageUI

class FormViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, MFMailComposeViewControllerDelegate {
    
    
    var backgroundView:UIView!
    var backgroundImageView: UIImageView!
    var categories: [Description]! = []
    var genres:[Description]! = []
    var foodGenres: [Description]! = []
    var drinkGenres: [Description]! = []
    var neighborhoods: [Description]! = []
    
    var iNeedView:UIView!
    var iNeedLabel:UILabel!
    var categoryButton:UIButton!
    
    var pickerBackgroundView:UIView!
    var categoryPicker:UIPickerView!
    var doneButton:UIButton!
    
    var iFeelLikeView:UIView!
    var iFeelLikeLabel:UILabel!
    var genreButton:UIButton!
    var addressButton:UIButton!
    
    var inView:UIView!
    var inLabel:UILabel!
    var neighborhoodButton:UIButton!
    
    var yelpButton:UIButton!
    var helpButton:UIButton!
    var suggestionButton:UIButton!
    
    var mapIconImage:UIImageView!
    var yelpIconImage:UIImageView!
    var contactIconImage:UIImageView!
    var tryAgainIconImage:UIImageView!
    
    var dividerView:UIView!
    var dividerView2:UIView!
    var dividerView3:UIView!

    var resultBackgroundView:UIView!
    var resultLabel: UILabel!
    var goToLabel: UILabel!
    var closeButton:UIButton!
    
    var matchResult:Match!
    var webView:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        backgroundView = UIView()
        backgroundView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        backgroundView.backgroundColor = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        backgroundView.contentMode = .ScaleAspectFill
        backgroundView.userInteractionEnabled = true
        view.addSubview(backgroundView)
        
        backgroundImageView = UIImageView()
        backgroundImageView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        backgroundImageView.image = UIImage(named:"grey_background")
        backgroundView.addSubview(backgroundImageView)
        
        getCategories()
        getNeighborhoods()
        getFood()
        getDrinks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectCategory(sender: UIButton!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("category", forKey: "buttonPressed")
        displayPickerView()
    }
    
    func selectGenre(sender: UIButton!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("genre", forKey: "buttonPressed")
        if (categoryButton.titleLabel!.text == "CATEGORY") {
            let cateogoryAlert = UIAlertView(title:"Hold up!", message: "Please select a category first.", delegate:nil,
                cancelButtonTitle:"OK")
            cateogoryAlert.show()
        } else {
            displayPickerView()
        }
    }
    
    func selectNeighborhood(sender: UIButton!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("neighborhood", forKey: "buttonPressed")
        displayPickerView()
    }
    
    func helpClicked(sender: UIButton!) {
        getMatch()
    }
    
    func displayPickerView() {
        pickerBackgroundView = UIView()
        pickerBackgroundView.frame = CGRectMake(0, self.view.frame.height - 250, self.view.frame.width, 250)
        pickerBackgroundView.backgroundColor = UIColor.blackColor()
        view.addSubview(pickerBackgroundView)
        
        categoryPicker = UIPickerView()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.frame = CGRectMake((pickerBackgroundView.frame.width - 200) / 2, 0, 200, 200)
        categoryPicker.backgroundColor = UIColor.blackColor()
        pickerBackgroundView.addSubview(categoryPicker)
        
        doneButton = UIButton()
        doneButton.frame = CGRectMake(self.view.frame.width - 70, 5, 65, 35)
        doneButton.backgroundColor = UIColor.blackColor()
        doneButton.setTitle("Select", forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "dismissPickerView:", forControlEvents: .TouchUpInside)
        doneButton.layer.borderWidth = 1;
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.cornerRadius = 5.0
        pickerBackgroundView.addSubview(doneButton)
        
        categoryButton.userInteractionEnabled = false
        genreButton.userInteractionEnabled = false
        neighborhoodButton.userInteractionEnabled = false
    }
    
    func dismissPickerView(sender: UIButton!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var defaultValue = defaults.objectForKey("buttonPressed") as! String
        
        if ((defaultValue == "category") && (categoryButton.titleLabel!.text == "CATEGORY")) {
            genres = drinkGenres
            categoryButton.setTitle("drink", forState: UIControlState.Normal)
        } else if ((defaultValue == "genre") && (genreButton.titleLabel!.text == "TYPE")) {
            genreButton.setTitle("something good", forState: UIControlState.Normal)
        } else if ((defaultValue == "neighborhood") && (neighborhoodButton.titleLabel!.text == "NEIGHBORHOOD")) {
            neighborhoodButton.setTitle("Doesn't Matter", forState: UIControlState.Normal)
        }
        pickerBackgroundView.removeFromSuperview()
        defaults.setObject("", forKey: "buttonPressed")
        categoryButton.userInteractionEnabled = true
        genreButton.userInteractionEnabled = true
        neighborhoodButton.userInteractionEnabled = true
    }
    
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        var buttonPressed = defaults.objectForKey("buttonPressed") as! String
        
        if buttonPressed == "category" {
            return categories.count
        } else if buttonPressed == "genre" {
            return genres.count
        } else if buttonPressed == "neighborhood" {
            return neighborhoods.count
        }
        
        return categories.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let defaults = NSUserDefaults.standardUserDefaults()
        var buttonPressed = defaults.objectForKey("buttonPressed") as! String
        
        if buttonPressed == "category" {
            return categories[row].name
        } else if buttonPressed == "genre" {
            return genres[row].name
        } else if buttonPressed == "neighborhood" {
            return neighborhoods[row].name
        }
        
        return categories[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var buttonPressed = defaults.objectForKey("buttonPressed") as! String
        
        if buttonPressed == "category" {
            var category = categories[row].name
            if category == "eat" {
                genres = foodGenres
                categoryButton.setTitle(category, forState: UIControlState.Normal)
            } else {
                genres = drinkGenres
                categoryButton.setTitle("drink", forState: UIControlState.Normal)
            }
        } else if buttonPressed == "genre" {
            genreButton.setTitle(genres[row].name, forState: UIControlState.Normal)
        } else if buttonPressed == "neighborhood" {
            neighborhoodButton.setTitle(neighborhoods[row].name, forState: UIControlState.Normal)
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var buttonPressed = defaults.objectForKey("buttonPressed") as! String
        
        var titleData = ""
        
        if buttonPressed == "category" {
            titleData = categories[row].name
            
        } else if buttonPressed == "genre" {
            titleData = genres[row].name
        } else if buttonPressed == "neighborhood" {
            titleData = neighborhoods[row].name
        }
        
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "AvenirNext-UltraLight", size: 20.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func getCategories() {
//        var urlString = "http://localhost:3000/activities"
        var urlString = "https://ineeda.herokuapp.com/activities"
        
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
            dispatch_async(dispatch_get_main_queue(), {
                self.categories = self.parseJsonData(data)
            })
        })
        task.resume()
    }
    
    func getNeighborhoods() {
//        var urlString = "http://localhost:3000/neighborhoods"
        var urlString = "https://ineeda.herokuapp.com/neighborhoods"
        
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
            dispatch_async(dispatch_get_main_queue(), {
                self.neighborhoods = self.parseJsonData(data)
                self.showButtons()
            })
        })
        task.resume()
    }
    
    func getFood() {
        //        var urlString = "http://localhost:3000/genres/2"
        var urlString = "https://ineeda.herokuapp.com/genres/2"
        
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
            dispatch_async(dispatch_get_main_queue(), {
                self.foodGenres = self.parseJsonData(data)
            })
        })
        task.resume()
    }
    
    func getDrinks() {
        //        var urlString = "http://localhost:3000/genres/1"
        var urlString = "https://ineeda.herokuapp.com/genres/1"
        
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
            dispatch_async(dispatch_get_main_queue(), {
                self.drinkGenres = self.parseJsonData(data)
            })
        })
        task.resume()
    }
    
    func showButtons() {
        // CATEGORIES
        iNeedView = UIView()
        iNeedView.frame = CGRectMake(0, 25, view.frame.width, (view.frame.height-165)/3)
        iNeedView.backgroundColor = UIColor.clearColor()
        backgroundView.addSubview(iNeedView)
        
        iNeedLabel = UILabel()
        iNeedLabel.text = "I wanna"
        iNeedLabel.backgroundColor = UIColor.clearColor()
        iNeedLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 40)
        iNeedLabel.textAlignment = NSTextAlignment.Center
        iNeedLabel.frame = CGRectIntegral(CGRectMake((iNeedView.frame.width-200)/2, (iNeedView.frame.height - 80) / 3, 200, 40))
        iNeedLabel.textColor = UIColor.whiteColor()
        iNeedView.addSubview(iNeedLabel)
        
        categoryButton = UIButton()
        categoryButton.frame = CGRectMake((iNeedView.frame.width-310)/2, iNeedView.frame.height - (40 + (iNeedView.frame.height - 70) / 3), 310, 70)
        categoryButton.backgroundColor = UIColor.whiteColor()
        categoryButton.setTitle("CATEGORY", forState: UIControlState.Normal)
        categoryButton.titleLabel!.font =  UIFont(name: "AvenirNext-UltraLight", size: 35)
        categoryButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        categoryButton.addTarget(self, action: "selectCategory:", forControlEvents: .TouchUpInside)
        categoryButton.layer.borderWidth = 1;
        categoryButton.layer.borderColor = UIColor.grayColor().CGColor
        categoryButton.layer.cornerRadius = 5.0
        iNeedView.addSubview(categoryButton)
        
        // GENRES
        iFeelLikeView = UIView()
        iFeelLikeView.frame = CGRectMake(0, 35 + iNeedView.frame.height, view.frame.width, (view.frame.height-165)/3)
        iFeelLikeView.backgroundColor = UIColor.clearColor()
        backgroundView.addSubview(iFeelLikeView)
        
        iFeelLikeLabel = UILabel()
        iFeelLikeLabel.text = "I feel like"
        iFeelLikeLabel.backgroundColor = UIColor.clearColor()
        iFeelLikeLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 40)
        iFeelLikeLabel.textAlignment = NSTextAlignment.Center
        iFeelLikeLabel.frame = CGRectIntegral(CGRectMake((iFeelLikeView.frame.width-200)/2, (iFeelLikeView.frame.height - 80) / 3, 200, 40))
        iFeelLikeLabel.textColor = UIColor.whiteColor()
        iFeelLikeView.addSubview(iFeelLikeLabel)
        
        genreButton = UIButton()
        genreButton.frame = CGRectMake((iFeelLikeView.frame.width-310)/2, iFeelLikeView.frame.height - (40 + (iFeelLikeView.frame.height - 70) / 3), 310, 70)
        genreButton.backgroundColor = UIColor.whiteColor()
        genreButton.setTitle("TYPE", forState: UIControlState.Normal)
        genreButton.titleLabel!.font =  UIFont(name: "AvenirNext-UltraLight", size: 35)
        genreButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        genreButton.addTarget(self, action: "selectGenre:", forControlEvents: .TouchUpInside)
        genreButton.layer.borderWidth = 1;
        genreButton.layer.borderColor = UIColor.grayColor().CGColor
        genreButton.layer.cornerRadius = 5.0
        iFeelLikeView.addSubview(genreButton)
        
        // NEIGHBORHOODS
        inView = UIView()
        inView.frame = CGRectMake(0, 35 + iNeedView.frame.height + iFeelLikeView.frame.height, view.frame.width, (view.frame.height-165)/3)
        inView.backgroundColor = UIColor.clearColor()
        backgroundView.addSubview(inView)
        
        inLabel = UILabel()
        inLabel.text = "in"
        inLabel.backgroundColor = UIColor.clearColor()
        inLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 40)
        inLabel.textAlignment = NSTextAlignment.Center
        inLabel.frame = CGRectIntegral(CGRectMake((inView.frame.width-120)/2, (inView.frame.height - 80) / 3, 120, 40))
        inLabel.textColor = UIColor.whiteColor()
        inView.addSubview(inLabel)
        
        neighborhoodButton = UIButton()
        neighborhoodButton.frame = CGRectMake((inView.frame.width-310)/2, inView.frame.height - (40 + (inView.frame.height - 70) / 3), 310, 70)
        neighborhoodButton.backgroundColor = UIColor.whiteColor()
        neighborhoodButton.setTitle("NEIGHBORHOOD", forState: UIControlState.Normal)
        neighborhoodButton.titleLabel!.font =  UIFont(name: "AvenirNext-UltraLight", size: 35)
        neighborhoodButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        neighborhoodButton.addTarget(self, action: "selectNeighborhood:", forControlEvents: .TouchUpInside)
        neighborhoodButton.layer.borderWidth = 1;
        neighborhoodButton.layer.borderColor = UIColor.grayColor().CGColor
        neighborhoodButton.layer.cornerRadius = 5.0
        inView.addSubview(neighborhoodButton)
        
        // HELP
        
        helpButton = UIButton()
        helpButton.frame = CGRectMake((inView.frame.width-150)/2, backgroundView.frame.height - 95, 150, 60)
        helpButton.backgroundColor = UIColor(red: 93.0/255.0, green: 204.0/255.0, blue: 175.0/255.0, alpha: 1.0)
        helpButton.setTitle("HELP!", forState: UIControlState.Normal)
        helpButton.titleLabel!.font =  UIFont(name: "AvenirNext-UltraLight", size: 40)
        helpButton.addTarget(self, action: "helpClicked:", forControlEvents: .TouchUpInside)
        helpButton.layer.borderWidth = 1;
//        helpButton.layer.borderColor = UIColor(red: 10.0/255.0, green: 214.0/255.0, blue: 180.0/255.0, alpha: 1.0).CGColor
        helpButton.layer.borderColor = UIColor(red: 93.0/255.0, green: 204.0/255.0, blue: 175.0/255.0, alpha: 1.0).CGColor
        helpButton.layer.cornerRadius = 5.0
        backgroundView.addSubview(helpButton)
    }
    
    func parseJsonData(data: NSData) -> [Description] {
        var error:NSError?
        var descriptions: [Description] = []
        
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray

        // Return nil if there are any errors
        if error != nil {
            println(error?.localizedDescription)
        }
        
        // Parse JSON data
        let jsonProducts = jsonResult as! [AnyObject]
        for jsonProduct in jsonProducts {
            
            let description = Description(
                name: jsonProduct["name"] as! String
            )
            println(description.name)
            println("NAME")
            descriptions.append(description)
        }
        return descriptions
    }
    
    func getMatch() {
        if let genre = genreButton.titleLabel?.text {
            if let neighborhood = neighborhoodButton.titleLabel?.text {
                var genre2 = genre.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                var neighborhood2 = neighborhood.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//                var urlString = "http://localhost:3000/matches/find?genre=\(genre2)&neighborhood=\(neighborhood2)"
                var urlString = "https://ineeda.herokuapp.com/matches/find?genre=\(genre2)&neighborhood=\(neighborhood2)"

                println(urlString)
                let request = NSURL(string: urlString)!
                let urlSession = NSURLSession.sharedSession()
                let task = urlSession.dataTaskWithURL(request){ (data, response, error) in
                    if error != nil {
                        let errorMessage = error.localizedDescription
                        let errorAlert = UIAlertView(title:"Error", message:error.localizedDescription as String, delegate:nil,
                            cancelButtonTitle:"OK")
                        errorAlert.show()
                        return
                    }
                    var error:NSError?
                    // Parse JSON data
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) {
                            var match = Match(
                                id: jsonResult["id"] as! Int,
                                name: jsonResult["name"] as! String,
                                link: jsonResult["link"] as! String
                            )
                            
                            var jsonAddress: String? = jsonResult["address"] as? String
                            match.address = jsonAddress ?? "2070 Fell Street"
                            match.city = "San Francisco"
                            match.state = "CA"
                            self.matchResult = match
                            self.displayResult(match)
                        }
                    })
                }
                task.resume()

            } else {
                displayAlertMessage("Error", alertDescription: "Please select a neighborhood.")
            }
        } else {
            displayAlertMessage("Error", alertDescription: "Please select a type of activity.")
        }
        println("AT END OF GET MATCH")
    }
    
    func displayAlertMessage(alertTitle:NSString, alertDescription:NSString) -> Void {
        let errorAlert = UIAlertView(title:alertTitle as String, message:alertDescription as String, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }
    
    func displayResult(result: Match) {
        resultBackgroundView = UIView()
        resultBackgroundView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        resultBackgroundView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        dividerView = UIView()
        dividerView.frame = CGRectMake(10, self.view.frame.height/3 * 2, self.view.frame.width - 20, 1)
        dividerView.backgroundColor = UIColor.whiteColor()
        resultBackgroundView.addSubview(dividerView)
        
        dividerView2 = UIView()
        dividerView2.frame = CGRectMake(10, self.view.frame.height/9 * 7, self.view.frame.width - 20, 0.5)
        dividerView2.backgroundColor = UIColor.whiteColor()
        resultBackgroundView.addSubview(dividerView2)
        
        dividerView3 = UIView()
        dividerView3.frame = CGRectMake(10, self.view.frame.height/9 * 8, self.view.frame.width - 20, 0.5)
        dividerView3.backgroundColor = UIColor.whiteColor()
        resultBackgroundView.addSubview(dividerView3)
        
        resultLabel = UILabel()
        resultLabel.text = result.name
        resultLabel.backgroundColor = UIColor.clearColor()
        resultLabel.textAlignment = NSTextAlignment.Center
        resultLabel.frame = CGRectIntegral(CGRectMake((iNeedView.frame.width-280)/2, 220, 280, 150))
        resultLabel.textColor = UIColor(red: 93.0/255.0, green: 204.0/255.0, blue: 175.0/255.0, alpha: 1.0)
        resultLabel.numberOfLines = 0
        resultBackgroundView.addSubview(resultLabel)
        
        closeButton = UIButton()
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.setTitle("Try Again", forState: UIControlState.Normal)
        closeButton.titleLabel!.font =  UIFont(name: "AvenirNext-UltraLight", size: 18)
        closeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        closeButton.addTarget(self, action: "dismissResultView:", forControlEvents: .TouchUpInside)
        resultBackgroundView.addSubview(closeButton)
        
        if result.id > 0 {
            goToLabel = UILabel()
            goToLabel.text = "Go to"
            goToLabel.backgroundColor = UIColor.clearColor()
            goToLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 40)
            goToLabel.textAlignment = NSTextAlignment.Center
            goToLabel.frame = CGRectIntegral(CGRectMake((iNeedView.frame.width-200)/2, 50, 200, (resultBackgroundView.frame.height/3*2 - 50)/3))
            goToLabel.textColor = UIColor.whiteColor()
            resultBackgroundView.addSubview(goToLabel)
         
            // ICONS
            mapIconImage = UIImageView(image: UIImage(named: "placeholder43"))
            mapIconImage.frame = CGRectMake(20, resultBackgroundView.frame.height/9 * 6 + (resultBackgroundView.frame.height/9-20)/2, 20, 20)
            resultBackgroundView.addSubview(mapIconImage)
            
            yelpIconImage = UIImageView(image: UIImage(named: "yelp1"))
            yelpIconImage.frame = CGRectMake(20, resultBackgroundView.frame.height/9 * 7 + (resultBackgroundView.frame.height/9-20)/2, 20, 20)
            resultBackgroundView.addSubview(yelpIconImage)
            
            tryAgainIconImage = UIImageView(image: UIImage(named: "curvearrow34"))
            tryAgainIconImage.frame = CGRectMake(22, resultBackgroundView.frame.height/9 * 8 + (resultBackgroundView.frame.height/9-15)/2, 15, 15)
            resultBackgroundView.addSubview(tryAgainIconImage)
            
            // BUTTONS
            addressButton = UIButton()
            addressButton.frame = CGRectMake(55, resultBackgroundView.frame.height - resultBackgroundView.frame.height/3, inView.frame.width - 55, resultBackgroundView.frame.height/9)
            addressButton.backgroundColor = UIColor.clearColor()
            addressButton.setTitle(result.address, forState: UIControlState.Normal)
            addressButton.titleLabel!.font =  UIFont(name: "AvenirNext-UltraLight", size: 18)
            addressButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            addressButton.addTarget(self, action: "showMapView:", forControlEvents: .TouchUpInside)
            resultBackgroundView.addSubview(addressButton)
            
            yelpButton = UIButton()
            yelpButton.frame = CGRectMake(55, resultBackgroundView.frame.height - resultBackgroundView.frame.height/9 * 2, inView.frame.width - 55, resultBackgroundView.frame.height/9)
            yelpButton.backgroundColor = UIColor.clearColor()
            yelpButton.setTitle("Check out the details on Yelp.", forState: UIControlState.Normal)
            yelpButton.titleLabel!.font =  UIFont(name: "AvenirNext-UltraLight", size: 18)
            yelpButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            yelpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            yelpButton.addTarget(self, action: "showYelpView:", forControlEvents: .TouchUpInside)
            yelpButton.tag = result.id
            resultBackgroundView.addSubview(yelpButton)
            
            closeButton.frame = CGRectMake(55, resultBackgroundView.frame.height - resultBackgroundView.frame.height/9, inView.frame.width - 40, resultBackgroundView.frame.height/9)
            
            resultLabel.frame = CGRectIntegral(CGRectMake(20, 20 + goToLabel.frame.height, inView.frame.width - 40, (resultBackgroundView.frame.height/3*2 - 50)/3*2))
            resultLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 50)
            
        } else {
            resultLabel.frame = CGRectIntegral(CGRectMake(20, 150, inView.frame.width - 40, 150))
            resultLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 30)
            
            // ICONS
            contactIconImage = UIImageView(image: UIImage(named: "mail114"))
            contactIconImage.frame = CGRectMake(20, resultBackgroundView.frame.height/9 * 6 + (resultBackgroundView.frame.height/9-20)/2, 20, 20)
            resultBackgroundView.addSubview(contactIconImage)
            
            tryAgainIconImage = UIImageView(image: UIImage(named: "curvearrow34"))
            tryAgainIconImage.frame = CGRectMake(22, resultBackgroundView.frame.height/9 * 7 + (resultBackgroundView.frame.height/9-20)/2, 20, 20)
            resultBackgroundView.addSubview(tryAgainIconImage)
            
            // BUTTONS
            suggestionButton = UIButton()
            suggestionButton.frame = CGRectMake(55, resultBackgroundView.frame.height - resultBackgroundView.frame.height/3, inView.frame.width - 55, resultBackgroundView.frame.height/9)
            suggestionButton.backgroundColor = UIColor.clearColor()
            suggestionButton.setTitle("Have a suggestion? Let us know.", forState: UIControlState.Normal)
            suggestionButton.titleLabel!.font =  UIFont(name: "AvenirNext-UltraLight", size: 18)
            suggestionButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            suggestionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            suggestionButton.addTarget(self, action: "showEmailView:", forControlEvents: .TouchUpInside)
            resultBackgroundView.addSubview(suggestionButton)
            
            closeButton.frame = CGRectMake(55, resultBackgroundView.frame.height - resultBackgroundView.frame.height/9 * 2, inView.frame.width - 55, resultBackgroundView.frame.height/9)
        }
        
        animateViews()
        println(result.name)
    }
    
    func showYelpView(sender: UIButton!) {
        println(sender.tag)
        println(matchResult.link)
        
        self.performSegueWithIdentifier("showWebView", sender: self)
    }
    
    func showMapView(sender: UIButton!) {
        println("MAP")
        self.performSegueWithIdentifier("showMapView", sender: self)
    }
    
    func showEmailView(sender: UIButton!) {
        println("IN EMAIL VIEW")
        sendEmail(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showWebView") {
            let newCont = segue.destinationViewController as! WebViewController
            newCont.matchResult = self.matchResult
        } else if (segue.identifier == "showMapView") {
            let newCont = segue.destinationViewController as! MapViewController
            newCont.match = self.matchResult
        }
    }
    
    func dismissResultView(sender: UIButton!) {
        animateViews()
        categoryButton.setTitle("CATEGORY", forState: UIControlState.Normal)
        genreButton.setTitle("TYPE", forState: UIControlState.Normal)
        neighborhoodButton.setTitle("NEIGHBORHOOD", forState: UIControlState.Normal)
    }
    
    func animateViews() {
        var views : (frontView: UIView, backView: UIView)
        
        if ((self.resultBackgroundView.superview) != nil) {
            views = (frontView: self.resultBackgroundView, backView: self.backgroundView)
        } else {
            views = (frontView: self.backgroundView, backView: self.resultBackgroundView)

        }
        
        let transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
        
        UIView.transitionFromView(views.frontView, toView: views.backView, duration: 0.5, options: transitionOptions, completion: nil)
        println("IN ANIMATION")
    }
    
    func sendEmail (sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            var composer = MFMailComposeViewController()
            
            composer.mailComposeDelegate = self
            composer.setToRecipients(["margaret.sandman@gmail.com"])
            composer.navigationBar.tintColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            
            //            presentViewController(composer, animated: true, completion: nil)
            presentViewController(composer, animated: true, completion: {
                
                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
                
                //setStatusBarStyle:UIStatusBarStyleLightContent];
                
            })
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
            
        case MFMailComposeResultSaved.value:
            println("Mail saved")
            
        case MFMailComposeResultSent.value:
            println("Mail sent")
            
        case MFMailComposeResultFailed.value:
            println("Failed to send mail: \(error.localizedDescription)")
            
        default:
            break
        }
        
        // Dismiss the Mail interface
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
