//
//  Settings.swift
//  project5
//
//  Created by mohsina rahman on 6/24/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation

class Settings
{
    let hasLaunchedBeforeKey = "hasLaunchedBefore"
    let countryKey = "Country"
    let defaultCountry = "USA"
    
    var countryCodeDictionary: [String: String] = [String: String]()
    var countryNames: [String] = [String]()
    
    private init()
    {
        populateCountryInfo()
    }
    
    func applicationHasLaunchedBefore()->Bool
    {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedBeforeKey)
        
        if(hasLaunchedBefore == false)
        {
            setDefaults()
        }
        
        return hasLaunchedBefore
    }
    
    func populateCountryInfo()
    {
        countryNames = ["Argentina","Australia", "Canada", "China", "France", "India", "United Kingdom", "USA"]
        
        countryCodeDictionary["Australia"] = "au"
        countryCodeDictionary["Argentina"] = "ar"
        countryCodeDictionary["Canada"] = "ca"
        countryCodeDictionary["China"] = "cz"
        countryCodeDictionary["France"] = "fr"
        countryCodeDictionary["India"] = "in"
        countryCodeDictionary["United Kingdom"] = "gb"
        countryCodeDictionary["USA"] = "us"
        
    }
    
    func getCountryName()->String
    {
        let countryName = UserDefaults.standard.string(forKey: countryKey)
        
        return countryName!
    }
    
    func setCountryName(countryName: String)
    {
         UserDefaults.standard.set(countryName, forKey: countryKey)
    }
    
    
    func getCountryCode()->String
    {
        let countryCode = countryCodeDictionary[getCountryName()]!
        
        return countryCode
    }
    
    func getCountryCode(countryName: String)->String
    {
        let countryCode = countryCodeDictionary[countryName]!
        
        return countryCode
    }
    
    
    func setDefaults()
    {
        UserDefaults.standard.set(true, forKey: hasLaunchedBeforeKey)
        UserDefaults.standard.set(defaultCountry, forKey: countryKey)
    }
    
    class func sharedInstance() -> Settings
    {
        struct Singleton
        {
            static var sharedInstance = Settings()
        }
        return Singleton.sharedInstance
    }
}
