//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Ellis Chang on 1/18/19.
//  Copyright © 2019 Ellis Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var splitTotalLabel: UILabel!
    @IBOutlet weak var splitSlider: UISlider!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        // This is a good place to retrieve the default tip percentage from UserDefaults
        // and use it to update the tip amount
        
        let defaults = UserDefaults.standard
        let defaultTipIndex = defaults.integer(forKey: "defaultTipIndex")
        tipControl.selectedSegmentIndex = defaultTipIndex
        calculateTip()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
        //defaults.setValue(billField.text, forKey: "defaultBill")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did disappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.becomeFirstResponder()
        
        self.title = "Tip Calculator"
        // Do any additional setup after loading the view, typically from a nib.
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "defaultBill") != nil) {
            let timeClose = defaults.object(forKey: "timeAtClose")
            if (NSDate().timeIntervalSince(timeClose as! Date) < 60*10) {
                billField.text = (defaults.object(forKey: "defaultBill") as! String)
            }
            else {
                billField.text = nil
            }
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        billField.attributedPlaceholder = NSAttributedString(string: formatter.currencySymbol)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    func calculateTip() {
        //format currency to current region
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        let tipPercentages = [0.1, 0.15, 0.2]
        
        //save current billfield
        let defaults = UserDefaults.standard
        defaults.setValue(billField.text, forKey: "defaultBill")
        defaults.synchronize()
        
        //make input compatible with comma separator
        let bill = Double(billField.text!.replacingOccurrences(of: ",", with: ".")) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        let splitNum = roundf(splitSlider.value / 1.0) * 1.0
        let splitTotal = total / Double(splitNum)
        
        let formattedSplitTotal = formatter.string(from: splitTotal as NSNumber)
        splitTotalLabel.text = String(format: "Total per person: %@", formattedSplitTotal!)
        tipLabel.text = formatter.string(from: tip as NSNumber)
        totalLabel.text = formatter.string(from: total as NSNumber)

    }
    
    @IBAction func splitTip(_ sender: UISlider) {
        calculateTip()
    }
    
    @IBAction func calculateTipPercent(_ sender: Any) {
        calculateTip()
    }
    
}

