//
//  NewsAPIConstants.swift
//  project5
//
//  Created by mohsina rahman on 6/21/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation
extension NewsAPIClient
{
    struct Constants
    {
        static let ApiScheme = "https"
        static let ApiHost = "newsapi.org"
        static let ApiPathTopHeadlines = "/v2/top-headlines"
        static let ApiPathEverything = "/v2/everything"
        static let ApiPathSources = "/v2/sources"
        
        static let HeaderAPIKey = "X-Api-Key"
        static let HeaderAPIValue = "20cbc29d65a14df7aad8a93ba476fa71"
        
        struct Parameters
        {
            static let countryKey = "country"
            static let categoryKey = "category"
            static let languageKey = "language"
            static let sourcesKey = "sources"
            static let topicKey = "q"
            static let pageSizeKey = "pageSize"
            static let pageKey = "page"

        }
        
        struct JSONResponseKeys
        {
            static let status = "status"
            static let totalResults = "totalResults"
            static let articles = "articles"
            static let source = "source"
            static let author = "author"
            static let title = "title"
            static let description = "description"
            static let url = "url"
            static let urlToImage = "urlToImage"
            static let publishedAt = "publishedAt"

        }
    }
}
