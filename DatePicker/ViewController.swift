//
//  ViewController.swift
//  DatePicker
//
//  Created by Gene De Lisa on 8/21/14.
//  Copyright (c) 2014 Gene De Lisa. All rights reserved.
//

import UIKit

// swiftlint:disable trailing_whitespace
// swiftlint:disable identifier_name

class ViewController: UIViewController {
    
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var dateLabel: UILabel!
    
    var theDate: Date! {
        didSet {
            updateUI()
        }
    }
    
    var datePicker = UIDatePicker()
    
    var pickerDateToolbar: UIToolbar!
    
    var formatter: DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full

        let chooseDateButton = UIBarButtonItem(title: NSLocalizedString("Choose Date", comment: ""), style: .plain, target: self, action: Selector(("addPicker:")))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: self, action: nil)
        self.toolbar.setItems( [spacer, chooseDateButton, spacer], animated: true)
        
        configDatePicker()
        self.theDate = datePicker.date
    }
    
    func updateUI() {
        DispatchQueue.main.async { [unowned self] in
            self.dateLabel.text = self.formatter.string(from: self.theDate)
        }
    }
    
    func updatePicker(date: Date) {
        print("new date \(date)")
        DispatchQueue.main.async { [unowned self] in
            self.datePicker.date = date
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var blurView: UIVisualEffectView!
    
    func blur() {
        // ios 8 stuff
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.isUserInteractionEnabled = false
        self.view.addSubview(blurView)
        blurView.frame = self.view.bounds
    }
    
    func unblur() {
        self.blurView.removeFromSuperview()
    }

    func configDatePicker() {
        datePicker.alpha = 1.0
        datePicker.backgroundColor = UIColor(red: 0, green: 0.9, blue: 0.9, alpha: 1.0)
        datePicker.addTarget(self,
                             action: #selector(datePickerDateChanged(_:)),
                             for: .valueChanged)

        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        datePicker.calendar = Calendar.current
        
        // just an example of restraining dates to a year. Only dates in 2014 will be valid
        var dateComponents = DateComponents()
        dateComponents.day = 31
        dateComponents.month = 12
        dateComponents.year = 2014
        datePicker.maximumDate = Calendar.current.date(from: dateComponents)

        dateComponents.day = 1
        dateComponents.month = 1
        dateComponents.year = 2014
        datePicker.minimumDate = Calendar.current.date(from: dateComponents)
        
        let done = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(doneWithDatePicker(_:)))
        let nextMonth = UIBarButtonItem(title: NSLocalizedString(">", comment: ""), style: .plain, target: self, action: #selector(nextMonth(_:)))
        let previousMonth = UIBarButtonItem(title: NSLocalizedString("<", comment: ""), style: .plain, target: self, action: #selector(previousMonth(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: self, action: nil)
        pickerDateToolbar = UIToolbar()
        pickerDateToolbar.items = [previousMonth, spacer, done, spacer, nextMonth]
        
        let screenRect = self.view.frame
        let pickerSize = self.datePicker.sizeThatFits(CGSize.zero)
        let x = screenRect.origin.x + (screenRect.size.width / 2) - (pickerSize.width / 2)
        let pickerRect = CGRect(x: x,
                                y: screenRect.origin.y + (screenRect.size.height / 2) - (pickerSize.height / 2),
                                width: pickerSize.width,
                                height: pickerSize.height)
        self.datePicker.frame = pickerRect
        
        let toolbarSize = self.pickerDateToolbar.sizeThatFits(CGSize.zero)
        // y right under the picker, and the same width as the picker
        pickerDateToolbar.frame = CGRect(x: x,
                                         y: pickerRect.origin.y + pickerRect.size.height,
                                         width: pickerSize.width,
                                         height: toolbarSize.height)
    }

    @objc
    func datePickerDateChanged(_ picker: UIDatePicker) {
        print("\(#function)")
        self.theDate = picker.date
    }
    
    /**
    called from toolbar button.
    */
    @objc
    func addPicker(_ sender: AnyObject) {
        self.blur()
        
        self.datePicker.date = self.theDate
        self.view.addSubview(self.datePicker)
        self.view.addSubview(self.pickerDateToolbar)
    }
    
    @objc
    func doneWithDatePicker(_ sender: AnyObject) {
        self.theDate = self.datePicker.date

        unblur()
        
        self.datePicker.removeFromSuperview()
        self.pickerDateToolbar.removeFromSuperview()
    }
    
    @objc
    func nextMonth(_ sender: AnyObject) {
        print("\(#function)")

        let currentCalendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = 1

        if let d = currentCalendar.date(byAdding: dateComponents, to: self.datePicker.date) {
            updatePicker(date: d)
        }

    }
    @objc
    func previousMonth(_ sender: AnyObject) {
        print("\(#function)")
        let currentCalendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = -1
        
        if let d = currentCalendar.date(byAdding: dateComponents, to: self.datePicker.date) {
            updatePicker(date: d)
        }
    }

}
