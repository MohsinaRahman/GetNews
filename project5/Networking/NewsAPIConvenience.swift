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
    func getArticlesForCategory(category: String, countryCode: String, completionHandler: @escaping (_ success: Bool, _ articlesArrayOfDictionary: [[String: AnyObject]]?, _ errorString: String?)->Void)
    {
        // Build URL
        let URL : URL
        var parameters : [String: AnyObject] = [:]
        
        // Add the method
        parameters[Constants.Parameters.categoryKey] = category as AnyObject
        parameters[Constants.Parameters.countryKey] = countryCode as AnyObject
        
        
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
            
            let articlesArrayOfDictionary = results?["articles"] as! [[String: AnyObject]]
            
            completionHandler(true, articlesArrayOfDictionary, nil)
        }
    }
    
    func getImageFromUrl(urlString: String, completionHandler: @escaping (_ success: Bool, _ urlString:String?, _ imageData: Data?, _ errorString: String?)->Void)
    {
        // Build the URL
        let escapedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: escapedURLString!)
        
        guard url != nil else
        {
            completionHandler(false, nil, nil, "Could not parse URL: \(urlString)")
            return
        }
        
        // Start the taks
        let task = URLSession.shared.dataTask(with: url!)
        {
            data, response, error in
            
            func sendError(_ error: String)
            {
                print(error)
                let internetOfflineErrorMessage = "NSURLErrorDomain Code=-1009"
                // let userInfo = [NSLocalizedDescriptionKey : error]
                if(error.contains(internetOfflineErrorMessage))
                {
                    completionHandler(false, nil, nil, error)
                }
                else
                {
                    completionHandler(false, nil, nil, error)
                }
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else
            {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else
            {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else
            {
                sendError("No data was returned by the request!")
                return
            }
            
            completionHandler(true, urlString, data, nil)
        }
        
        task.resume()
    }
}
