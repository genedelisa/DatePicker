//
//  ViewController.swift
//  DatePicker
//
//  Created by Gene De Lisa on 8/21/14.
//  Copyright (c) 2014 Gene De Lisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var dateLabel: UILabel!
    
    var theDate:NSDate! {
        didSet {
            updateUI()
        }
    }
    
    var datePicker = UIDatePicker()
    
    var pickerDateToolbar:UIToolbar!
    
    var formatter:NSDateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        self.theDate = NSDate.date()
        

        var chooseDateButton = UIBarButtonItem(title: NSLocalizedString("Choose Date", comment: ""), style: .Plain, target: self, action: "addPicker:")
        
        
        var spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: self, action: nil)
        self.toolbar.setItems( [chooseDateButton], animated: true)
        
        configDatePicker()
    }
    
    func updateUI() {
        dateLabel.text = formatter.stringFromDate(theDate)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var blurView:UIVisualEffectView!
    func blur() {
        // ios 8 stuff
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        blurView.userInteractionEnabled = false
        self.view.addSubview(blurView)
        blurView.frame = self.view.bounds
    }
    
    func unblur() {
        self.blurView.removeFromSuperview()
    }
    
    func configDatePicker() {
        datePicker.alpha = 1.0
        datePicker.backgroundColor = UIColor(red: 0, green: 0.9, blue: 0.9, alpha: 1.0)
        //        datePicker.addTarget(self,
        //            action:"datePickerDateChanged:",
        //            forControlEvents:.ValueChanged)

        datePicker.datePickerMode = .Date
        datePicker.timeZone = NSTimeZone.localTimeZone()
        datePicker.calendar = NSCalendar.currentCalendar()
        
        let dateComponents = NSDateComponents()
        dateComponents.day = 31
        dateComponents.month = 12
        dateComponents.year = 2014
        datePicker.maximumDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        dateComponents.day = 1
        dateComponents.month = 1
        dateComponents.year = 2014
        datePicker.minimumDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        var done = UIBarButtonItem(title:  NSLocalizedString("Done", comment: ""), style: .Plain, target: self, action: "doneWithDatePicker:")
        var nextMonth = UIBarButtonItem(title: NSLocalizedString(">", comment: ""), style: .Plain, target: self, action: "nextMonth:")
        var previousMonth = UIBarButtonItem(title: NSLocalizedString("<", comment: ""), style: .Plain, target: self, action: "previousMonth:")
        var spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: self, action: nil)
        pickerDateToolbar = UIToolbar()
        pickerDateToolbar.items = [previousMonth, spacer,done,spacer, nextMonth]
        
        var screenRect = self.view.frame
        var pickerSize = self.datePicker.sizeThatFits(CGSizeZero)
        var x = screenRect.origin.x + (screenRect.size.width / 2) - (pickerSize.width / 2)
        var pickerRect = CGRectMake(x,
            screenRect.origin.y + (screenRect.size.height / 2) - (pickerSize.height / 2),
            pickerSize.width,
            pickerSize.height)
        self.datePicker.frame = pickerRect
        
        var toolbarSize = self.pickerDateToolbar.sizeThatFits(CGSizeZero)
        pickerDateToolbar.frame = CGRectMake(x,
            pickerRect.origin.y + pickerRect.size.height, // right under the picker
            pickerSize.width, // make them the same width
            toolbarSize.height)
    }
    
    func datePickerDateChanged(dp:UIDatePicker) {
        self.theDate = dp.date
    }
    
    /**
    called from toolbar button.
    */
    func addPicker(sender : AnyObject) {
        self.blur()
        self.datePicker.date = self.theDate
        self.view.addSubview(self.datePicker)
        self.view.addSubview(self.pickerDateToolbar)
    }
    
    func doneWithDatePicker(sender : AnyObject) {
        self.datePicker.removeFromSuperview()
        self.pickerDateToolbar.removeFromSuperview()
        unblur()
        self.theDate = self.datePicker.date
    }
    
    func nextMonth(sender : AnyObject) {
        let currentCalendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = 1
        self.datePicker.date = currentCalendar.dateByAddingComponents(dateComponents, toDate: self.datePicker.date, options: nil)

    }
    func previousMonth(sender : AnyObject) {
        let currentCalendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = -1
        self.datePicker.date = currentCalendar.dateByAddingComponents(dateComponents, toDate: self.datePicker.date, options: nil)
    }

}

