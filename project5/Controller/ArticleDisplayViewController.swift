//
//  ArticleDisplayViewController.swift
//  project5
//
//  Created by mohsina rahman on 6/23/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class ArticleDisplayViewController: UIViewController, WKNavigationDelegate
{
    var dataController:DataController!
    var fetchedFavoriteArticleListResultsController:NSFetchedResultsController<ArticleList>!
    var fetchedSharedArticleResultsController:NSFetchedResultsController<SharedArticle>!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var shaButton: UIBarButtonItem!
    
    var article: Article?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupFavoriteArticleListFetchedResultsController()
        setupSharedArticleFetchedResultsController()
        
        updateControls()
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.blue
        self.view.addSubview(activityIndicator)
        
        webView.navigationDelegate = self
        print("Started Loading")
        // Do any additional setup after loading the view.
        loadURL()
    }
    
    func loadURL()
    {
        if(article?.url != nil)
        {
            let url = URL(string: article!.url!)
            let request = URLRequest(url:url!)
            activityIndicator.startAnimating()
            view.alpha = CGFloat(0.5)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("Loading finished")
        view.alpha = CGFloat(1.0)
        activityIndicator.stopAnimating()
        
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView)
    {
        print("Load finished 2")
    }
    
    @IBAction func favButtonPressed(_ sender: Any)
    {
        if(self.fetchedFavoriteArticleListResultsController.fetchedObjects!.count > 0)
        {
            let favoriteList = self.fetchedFavoriteArticleListResultsController.fetchedObjects![0]
            
            if(isArticleInfavorite())
            {
                // Remove from favorite
                var articleToDelete: Article? = nil
                for article in favoriteList.articles!
                {
                    if((article as! Article).url == self.article?.url)
                    {
                        articleToDelete = (article as! Article)
                        break
                    }
                }
                
                if(articleToDelete != nil)
                {
                    self.dataController.viewContext.delete(articleToDelete!)
                }
            }
            else
            {
                // Add to favorite
                let newFavArticle = Article(context: self.dataController.viewContext)
                newFavArticle.setProperties(article: self.article!)
                newFavArticle.articleList = favoriteList
            }
        }
        else
        {
            
        }
        
        try? self.dataController.viewContext.save()
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
            self.dataController.backgroundContext.perform
            {
                
                let s = SharedArticle(context: self.dataController.viewContext)
                s.lastShareDate = Date()
                s.article = Article(context: self.dataController.viewContext)
                s.article?.setProperties(article: self.article!)
                
                print("Saving Shared Article")
                try? self.dataController.viewContext.save()
            }
        }
    }
    
    func isArticleInfavorite()->Bool
    {
        if((fetchedFavoriteArticleListResultsController.fetchedObjects?.count)! > 0)
        {
            let articleList = fetchedFavoriteArticleListResultsController.fetchedObjects![0]
            let articles = articleList.articles
            
            print(articles!.count)
            for article in articles!
            {
                if((article as! Article).url == self.article!.url)
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    func updateControls()
    {
        favButton.title = isArticleInfavorite() ? "Unfavorite" : "Favorite"
    }
    
}


extension ArticleDisplayViewController: NSFetchedResultsControllerDelegate
{
    fileprivate func setupFavoriteArticleListFetchedResultsController()
    {
        // Create the fetch request
        let fetchRequest:NSFetchRequest<ArticleList> = ArticleList.fetchRequest()
        
        // Set up the predicate
        let predicate = NSPredicate(format: "categoryName = %@", "favorite")
        fetchRequest.predicate = predicate
        
        // Set up the sort order
        let sortDescriptor = NSSortDescriptor(key: "lastDownloaded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create the fetch results controller
        fetchedFavoriteArticleListResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set up the delegate
        fetchedFavoriteArticleListResultsController.delegate = self
        
        // Perform the fetch
        do
        {
            try fetchedFavoriteArticleListResultsController.performFetch()
            
            if(fetchedFavoriteArticleListResultsController.fetchedObjects?.count == 0)
            {
                
                print("Creating new article list")
                let articleList = ArticleList(context: self.dataController.viewContext)
                articleList.categoryName = "favorite"
                articleList.countryCode = "n/a"
                
                try? self.dataController.viewContext.save()
                
            }
        }
        catch
        {
            fatalError("The Favorite ArticleList fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    fileprivate func setupSharedArticleFetchedResultsController()
    {
        // Create the fetch request
        let fetchRequest:NSFetchRequest<SharedArticle> = SharedArticle.fetchRequest()
        
        // Set up the sort order
        let sortDescriptor = NSSortDescriptor(key: "lastShareDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create the fetch results controller
        fetchedSharedArticleResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set up the delegate
        fetchedSharedArticleResultsController.delegate = self
        
        // Perform the fetch
        do
        {
            try fetchedSharedArticleResultsController.performFetch()
        }
        catch
        {
            fatalError("The Shared Article fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type
        {
        case .insert:
            print("Insert Operation")
            DispatchQueue.main.async
                {
                    self.updateControls()
            }
            break
        case .delete:
            print("Delete Operation")
            DispatchQueue.main.async
                {
                    self.updateControls()
            }
            break
        case .update:
            print("Update Operation")
            DispatchQueue.main.async
                {
                    self.updateControls()
            }
            break
        case .move:
            print("Move Operation")
            DispatchQueue.main.async
                {
                    self.updateControls()
            }
            break
        }
    }
}
