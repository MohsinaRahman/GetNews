//
//  ArticleDisplayViewController.swift
//  project5
//
//  Created by mohsina rahman on 6/23/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import WebKit

class ArticleDisplayViewController: UIViewController
{
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var shaButton: UIBarButtonItem!
    
    var article: Article?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(isArticleInfavorite())
        {
            favButton.title = "Unfavorite"
        }
        else
        {
            favButton.title = "Favorite"
        }
        

        // Do any additional setup after loading the view.
        loadURL()
    }
    
    func loadURL()
    {
        if(article?.url != nil)
        {
            let url = URL(string: article!.url!)
            let request = URLRequest(url:url!)
            webView.load(request)
        }
    }
    @IBAction func favButtonPressed(_ sender: Any)
    {
        if(!isArticleInfavorite())
        {
            if(ArticleDataSource.sharedInstance().articleFavoriteArray == nil)
            {
                ArticleDataSource.sharedInstance().articleFavoriteArray = [article!]
            }
            else
            {
                ArticleDataSource.sharedInstance().articleFavoriteArray?.append(article!)
            }
            
            favButton.title = "Unfavorite"
        }
        else
        {
            var index = 0
            for article in ArticleDataSource.sharedInstance().articleFavoriteArray!
            {
                if(article.url == self.article?.url)
                {
                    break
                }
                index = index + 1
            }
            
            ArticleDataSource.sharedInstance().articleFavoriteArray!.remove(at: index)
            
            favButton.title = "Favorite"
        }
    }
    
    @IBAction func shaButtonPressed(_ sender: Any)
    {
        let url = URL(string: self.article!.url!)
        
        if(url != nil)
        {
            let controller = UIActivityViewController(activityItems:[url!], applicationActivities: nil)
            controller.completionWithItemsHandler = self.activityViewControllerCompletion
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func activityViewControllerCompletion(activity: UIActivityType?, completed: Bool, returnItems: [Any]?, activityError: Error?)
    {
        if completed
        {
            if(ArticleDataSource.sharedInstance().articleSharedArray == nil)
            {
                ArticleDataSource.sharedInstance().articleSharedArray = [article!]
            }
            else
            {
                ArticleDataSource.sharedInstance().articleSharedArray?.append(article!)
            }
        }
    }
    
    func isArticleInfavorite()->Bool
    {
        if(ArticleDataSource.sharedInstance().articleFavoriteArray != nil)
        {
            for article in ArticleDataSource.sharedInstance().articleFavoriteArray!
            {
                if(article.url! == self.article?.url!)
                {
                    return true
                }
            }
        }
        
        return false
    }
    
}
