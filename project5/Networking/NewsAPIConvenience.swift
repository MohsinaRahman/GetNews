//
//  NewsAPIConvenience.swift
//  project5
//
//  Created by mohsina rahman on 6/21/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation

extension NewsAPIClient
{
    func getArticlesForCategory(category: String, completionHandler: @escaping (_ success: Bool, _ articles: [Article]?, _ errorString: String?)->Void)
    {
        // Build URL
        let URL : URL
        var parameters : [String: AnyObject] = [:]
        
        // Add the method
        parameters[Constants.Parameters.categoryKey] = category as AnyObject
        parameters[Constants.Parameters.countryKey] = "us" as AnyObject
    
        
        URL = buildURL(host: Constants.ApiHost, apiPath: Constants.ApiPathTopHeadlines, parameters: parameters)
        print(URL.absoluteString)
       
        let headers: [String: String] =
        [
            Constants.HeaderAPIKey:Constants.HeaderAPIValue
        ]
        let request = configureRequest(url: URL, methodType: "GET", headers: headers, jsonBody: nil)
        
        makeNetworkRequest(request: request, ignoreInitialCharacters: false)
        {
            (results: AnyObject?, error: Error?)->Void in
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                if((error! as NSError).domain == "noInternetConnection")
                {
                    completionHandler(false, nil, "No Internet Connection")
                }
                else
                {
                    completionHandler(false, nil, "Error downloading results from Flickr")
                }
                
                return
            }
            
            print(results!)
            let articles = results?["articles"] as! [[String: AnyObject]]
            
            completionHandler(true,nil, nil)
        }
    }
}
