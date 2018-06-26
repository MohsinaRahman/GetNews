//
//  Article+Extra.swift
//  project5
//
//  Created by mohsina rahman on 6/26/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation

extension Article
{
    func setProperties(article: [String: AnyObject])
    {
        author = article[NewsAPIClient.Constants.JSONResponseKeys.author] as? String
        title = article[NewsAPIClient.Constants.JSONResponseKeys.title] as? String
        desc = article[NewsAPIClient.Constants.JSONResponseKeys.description] as? String
        url = article[NewsAPIClient.Constants.JSONResponseKeys.url] as? String
        urlToImage = article[NewsAPIClient.Constants.JSONResponseKeys.urlToImage] as? String
        imageData = nil
        publishedAt = article[NewsAPIClient.Constants.JSONResponseKeys.publishedAt] as? String
        
        
        let source = article[NewsAPIClient.Constants.JSONResponseKeys.source] as? [String:AnyObject]
        sourceName = source![NewsAPIClient.Constants.JSONResponseKeys.sourceName] as? String
    }
    
    func setProperties(article: Article)
    {
        author = article.author
        title = article.title
        desc = article.desc
        url = article.url
        urlToImage = article.urlToImage
        imageData = article.imageData
        publishedAt = article.publishedAt
        sourceName = article.sourceName
    }
}
