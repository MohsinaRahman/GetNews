//
//  ArticleDataSource.swift
//  project5
//
//  Created by mohsina rahman on 6/23/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation

class ArticleDataSource
{
    var articleBusinessArray :[Article]? = nil
    var articleEntertainmentArray :[Article]? = nil
    var articleSportsArray :[Article]? = nil
    var articleHealthArray :[Article]? = nil
    var articleGeneralArray :[Article]? = nil
    var articleTechnologyArray :[Article]? = nil
    var articleScienceArray :[Article]? = nil
    var articleFavoriteArray :[Article]? = nil
    var articleReadingListArray :[Article]? = nil
    var articleSharedArray :[Article]? = nil
    
    class func sharedInstance() -> ArticleDataSource
    {
        struct Singleton
        {
            static var sharedInstance = ArticleDataSource()
        }
        return Singleton.sharedInstance
    }
}
