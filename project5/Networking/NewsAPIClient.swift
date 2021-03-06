//
//  NewsAPIClient.swift
//  project5
//
//  Created by mohsina rahman on 6/21/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation

class NewsAPIClient: NSObject
{
    
    override init()
    {
        super.init()
    }
    
    func buildURL(host: String, apiPath: String, parameters: [String:AnyObject]?) -> URL
    {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = host
        components.path = apiPath
        components.queryItems = [URLQueryItem]()
        
        if(parameters != nil)
        {
            for (key, value) in parameters!
            {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    func configureRequest(url: URL, methodType: String, headers: [String: String]?, jsonBody: String?)->URLRequest
    {
        var request = URLRequest(url: url)
        
        request.httpMethod = methodType
        
        if(headers != nil)
        {
            for(key, value) in headers!
            {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if(jsonBody != nil)
        {
            request.httpBody = jsonBody!.data(using: .utf8)
        }
        
        return request
    }
    
    func makeNetworkRequest(request: URLRequest, ignoreInitialCharacters: Bool, completionHandler: @escaping (AnyObject?,Error?)->Void)
    {
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            
            func sendError(_ error: String)
            {
                print(error)
                let internetOfflineErrorMessage = "NSURLErrorDomain Code=-1009"
                let userInfo = [NSLocalizedDescriptionKey : error]
                if(error.contains(internetOfflineErrorMessage))
                {
                    completionHandler(nil, NSError(domain: "noInternetConnection", code: 1, userInfo: userInfo))
                }
                else
                {
                    completionHandler(nil, NSError(domain: "makeNetworkRequest", code: 2, userInfo: userInfo))
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
            
            // Parse the data and use the data (happens in completion handler)
            let (parsedResult, error) = self.parseData(data: data, ignoreInitialCharacters: ignoreInitialCharacters)
            completionHandler(parsedResult, error)
        }
        
        task.resume()
    }
    
    private func parseData(data: Data, ignoreInitialCharacters: Bool)->(AnyObject?, Error?)
    {
        var actualData: Data
        if(ignoreInitialCharacters)
        {
            let range = Range(5..<data.count)
            actualData = data.subdata(in: range)
        }
        else
        {
            actualData = data
        }
        
        var result: (AnyObject?, Error?)
        
        do
        {
            let parsedResult = try JSONSerialization.jsonObject(with: actualData, options: .allowFragments) as AnyObject
            result = (parsedResult, nil)
        }
        catch
        {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(actualData)'"]
            let error = NSError(domain: "processData", code: 2, userInfo: userInfo)
            result = (nil, error)
        }
        
        return result
    }
    
    class func sharedInstance() -> NewsAPIClient
    {
        struct Singleton
        {
            static var sharedInstance = NewsAPIClient()
        }
        return Singleton.sharedInstance
    }
}
