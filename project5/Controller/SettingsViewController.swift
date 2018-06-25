//
//  SettingsViewController.swift
//  project5
//
//  Created by mohsina rahman on 6/24/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var pickerView: UIPickerView!
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.setInitialPickerViewValue()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return Settings.sharedInstance().countryNames.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return Settings.sharedInstance().countryNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let countryName = Settings.sharedInstance().countryNames[row]
        let countryCode = Settings.sharedInstance().getCountryCode(countryName: countryName)
        
        print ("\(countryCode) => \(countryName)")
        
        Settings.sharedInstance().setCountryName(countryName: countryName)
    }
    
    func setInitialPickerViewValue()
    {
        let countryName = Settings.sharedInstance().getCountryName()
        
        var index = 0
        for country in Settings.sharedInstance().countryNames
        {
            if(country == countryName)
            {
                print(countryName)
                print(index)
                break
            }
            
            index = index + 1
        }
        
        self.pickerView.selectRow(index, inComponent: 0, animated: true)
    }
}
