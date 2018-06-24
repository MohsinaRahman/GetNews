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
        if(ArticleDataSource.sharedInstance().articleFavoriteArray == nil)
        {
            ArticleDataSource.sharedInstance().articleFavoriteArray = [article!]
        }
        else
        {
            ArticleDataSource.sharedInstance().articleFavoriteArray?.append(article!)
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
    
}
