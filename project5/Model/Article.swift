//
//  Article.swift
//  project5
//
//  Created by mohsina rahman on 6/21/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation

struct Article
{
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    
    init (article: [String: AnyObject])
    {
        author = article[NewsAPIClient.Constants.JSONResponseKeys.author] as? String
        title = article[NewsAPIClient.Constants.JSONResponseKeys.title] as? String
        description = article[NewsAPIClient.Constants.JSONResponseKeys.description] as? String
        url = article[NewsAPIClient.Constants.JSONResponseKeys.url] as? String
        urlToImage = article[NewsAPIClient.Constants.JSONResponseKeys.urlToImage] as? String
        publishedAt = article[NewsAPIClient.Constants.JSONResponseKeys.publishedAt] as? String
    }
}

