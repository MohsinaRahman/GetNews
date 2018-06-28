//
//  ArticleListViewController.swift
//  project5
//
//  Created by mohsina rahman on 6/21/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import CoreData

class ArticleTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var dataController:DataController!
    var fetchedArticleListResultsController:NSFetchedResultsController<ArticleList>!
    var fetchedArticleResultsController:NSFetchedResultsController<Article>!
    var fetchedSharedArticleResultsController:NSFetchedResultsController<SharedArticle>!
    var saveObserverToken: Any?
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var sharedArticle: Article?
    var category:String = ""
    var articleList: ArticleList!
    
    let minimimRowHeight:CGFloat = 128.0
    let placeHolderImage = UIImage(named: "no_image_available")
    var downloadedImages : [String: UIImage?] = [String: UIImage?]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addSaveNotificationObserver()
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if(category == "favorite" || category == "share")
        {
            let buttonHome = UIBarButtonItem(image: #imageLiteral(resourceName: "home_1"), style: .plain, target: self, action: #selector(goHome))
            navigationItem.rightBarButtonItems = [buttonHome]
        }
        else
        {
            let buttonHome = UIBarButtonItem(image: #imageLiteral(resourceName: "home_1"), style: .plain, target: self, action: #selector(goHome))
            let buttonRefresh = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(refreshArticles))
            navigationItem.rightBarButtonItems = [buttonHome, buttonRefresh]
        }
        
        switch(category)
        {
            case "general":
                navigationItem.title = "General Headlines"
            case "health":
                navigationItem.title = "Health Headlines"
            case "business":
                navigationItem.title = "Business Headlines"
            case "science":
                navigationItem.title = "Science Headlines"
            case "sports":
                navigationItem.title = "Sports Headlines"
            case "technology":
                navigationItem.title = "Technology Headlines"
            case "entertainment":
                navigationItem.title = "Entertainment Headlines"
            
            
            case "favorite":
                navigationItem.title = "Favorite List"
            case "share":
                navigationItem.title = "Shared List"
            
            default:
                navigationItem.title = "Other Headlines"
        }
        
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.blue
        view.addSubview(activityIndicator)
        
        if(category == "favorite")
        {
            
        }
        else
        {
            getFreshNewsArticles()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        downloadedImages.removeAll()
        
        setupArticleListFetchedResultsController()
        setupArticleFetchedResultsController()
        setupSharedArticleFetchedResultsController()
        
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        removeSaveNotificationObserver()
        
        super.viewDidDisappear(animated)
    }
    
    func getFreshNewsArticles()
    {
        activityIndicator.startAnimating()
        view.alpha = CGFloat(0.5)
        
        NewsAPIClient.sharedInstance().getArticlesForCategory(category: category, countryCode: Settings.sharedInstance().getCountryCode())
        {
            (_ success: Bool, _ articlesArrayOfDictionary: [[String: AnyObject]]?, _ errorString: String?)->Void in
            
            if(success)
            {
                self.dataController.backgroundContext.perform
                {
                    // Get the context to the background object
                    let articlelistID = self.articleList.objectID
                    let articleList1 = self.dataController.backgroundContext.object(with: articlelistID) as? ArticleList
                    articleList1?.lastDownloaded = Date()
                    
                    // Create new articles that are new
                    for dictionary in articlesArrayOfDictionary!
                    {
                        let urlString = (dictionary[NewsAPIClient.Constants.JSONResponseKeys.url] as? String)!
                        if(!self.isArticleAlreadyInArticleList(url: urlString, articleList: articleList1!))
                        {
                            // Create the article
                            let article = Article(context: self.dataController.backgroundContext)
                            // Set the properties of the article based on the dictionary
                            article.setProperties(article: dictionary)
                            article.articleList = articleList1
                        }
                    }
                    
                    // Delete old articles that are no longer there
                    let itemsToDelete = self.getArticlesToDelete(oldArticleList: articleList1!, newArticlesArrayOfDictionary: articlesArrayOfDictionary)
                    for objectID in itemsToDelete
                    {
                        let articleToDelete = self.dataController.backgroundContext.object(with: objectID) as! Article
                        articleList1?.removeFromArticles(articleToDelete)
                        self.dataController.backgroundContext.delete(articleToDelete)
                    }
                    
                    // Save on the background context
                    try? self.dataController.backgroundContext.save()
                }
                
                DispatchQueue.main.async
                {
                    self.activityIndicator.stopAnimating()
                    self.view.alpha = CGFloat(1.0)
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.activityIndicator.stopAnimating()
                    self.view.alpha = CGFloat(1.0)
                }
                self.showError(message: errorString!)
            }
        }
    }
    
    func isArticleAlreadyInArticleList(url:String, articleList: ArticleList)->Bool
    {
        var present = false
        
        let articles = articleList.articles!
        
        for article in articles
        {
            if((article as! Article).url == url)
            {
                present = true
                break
            }
        }
        
        return present
    }
    
    
    func getArticlesToDelete(oldArticleList: ArticleList, newArticlesArrayOfDictionary: [[String: AnyObject]]?)->Set<NSManagedObjectID>
    {
        var itemsToDelete = Set<NSManagedObjectID>()
        
        let oldArticles = oldArticleList.articles!
        for article in oldArticles
        {
            var delete = true
            for dictionary in newArticlesArrayOfDictionary!
            {
                let urlString = (dictionary[NewsAPIClient.Constants.JSONResponseKeys.url] as? String)!
                if((article as! Article).url == urlString)
                {
                    delete = false
                    break
                }
            }
            
            if(delete)
            {
                itemsToDelete.insert((article as! Article).objectID)
            }
        }
        
        return itemsToDelete
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let fetchedResults = fetchedArticleResultsController.fetchedObjects!.count
        
        return max(fetchedResults, 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell")! as! ArticleTableViewCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        
        let articleObjectID = fetchedArticleResultsController.object(at: indexPath).objectID
        let article = fetchedArticleResultsController.object(at: indexPath)
        
        // Set the headline
        cell.headlineLabel.text = article.title
        // Set the source
        cell.sourceLabel.text = article.sourceName
        // Set the image
        updateImageForCell(cell: cell, cellForRowAt: indexPath, article: article, articleObjectID: articleObjectID)
 
        return cell
    }
    
    func updateImageForCell(cell: ArticleTableViewCell, cellForRowAt indexPath: IndexPath, article: Article, articleObjectID: NSManagedObjectID)
    {
        if(article.imageData == nil)
        {
            cell.articleImageView.image = placeHolderImage
            
            if(article.urlToImage != nil)
            {
                // Create the activity indicator, set it's properties and start animating
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                cell.addSubview(activityIndicator)
                activityIndicator.center = CGPoint(x: cell.articleImageView.bounds.size.width/2, y: cell.articleImageView.bounds.size.height/2)
                activityIndicator.color = UIColor.black
                activityIndicator.startAnimating()
                
                
                NewsAPIClient.sharedInstance().getImageFromUrl(urlString: article.urlToImage!)
                {
                    (_ success: Bool, _ imagePath: String?, _ imageData: Data?, _ errorString: String?)->Void in
                    
                        if(success)
                        {
                            self.dataController.backgroundContext.perform
                            {
                                // Get the article
                                let articleNew = self.dataController.backgroundContext.object(with: articleObjectID) as! Article
                                
                                if(articleNew.url == article.url)
                                {
                                    // Update the article
                                    articleNew.imageData = imageData
                                    // Save on the background context
                                    try? self.dataController.backgroundContext.save()
                                }
                            }
                        }
                        else
                        {
                            print("Error downloading image for article: \(article.title!) => \(article.urlToImage!)")
                            print("Error code: \(errorString!)")
                        }
                    
                        DispatchQueue.main.async
                        {
                            // Stop the animation of the activity indicator
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        }
                }
            }
            else
            {
                print("Article has no image: \(article.title!)")
            }
        }
        else
        {
            DispatchQueue.main.async
            {
                if(self.downloadedImages[article.urlToImage!] != nil)
                {
                    cell.articleImageView.image = self.downloadedImages[article.urlToImage!]!
                }
                else
                {
                    self.downloadedImages[article.urlToImage!] = UIImage(data: article.imageData!)
                    cell.articleImageView.image = self.downloadedImages[article.urlToImage!]!
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ArticleDisplayViewController") as! ArticleDisplayViewController
        
        controller.dataController = dataController
        controller.article = fetchedArticleResultsController.object(at: indexPath)
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let shareAction = contextForShareAction(forRowAtIndexPath: indexPath)
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [shareAction])
        
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete)
        {
            let articleObjectID = fetchedArticleResultsController.object(at: indexPath).objectID
            
            dataController.backgroundContext.perform
            {
                // Get the article
                let article = self.dataController.backgroundContext.object(with: articleObjectID) as! Article
                // Delete the article
                self.dataController.backgroundContext.delete(article)
                // Save on the background context
                try? self.dataController.backgroundContext.save()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return minimimRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return max(minimimRowHeight, UITableViewAutomaticDimension)
    }
    
    func contextForShareAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction
    {
        sharedArticle = fetchedArticleResultsController.object(at: indexPath)
        
        let action = UIContextualAction(style: .normal,title: "Share")
        {
            (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            
            let url = URL(string: self.sharedArticle!.url!)
            
            if(url != nil)
            {
                let controller = UIActivityViewController(activityItems:[url!], applicationActivities: nil)
                controller.completionWithItemsHandler = self.activityViewControllerCompletion
                self.present(controller, animated: true, completion: nil)
            }
            
            completionHandler(true)
            
        }
        action.backgroundColor = UIColor.blue
        
        return action
    }
    
    func activityViewControllerCompletion(activity: UIActivityType?, completed: Bool, returnItems: [Any]?, activityError: Error?)
    {
        if completed
        {
            dataController.backgroundContext.perform
            {
                
                let s = SharedArticle(context: self.dataController.backgroundContext)
                s.lastShareDate = Date()
                s.article = Article(context: self.dataController.backgroundContext)
                s.article?.setProperties(article: self.sharedArticle!)
                
                try? self.dataController.backgroundContext.save()
            }
        }
    }
    
    
    
    
    @objc func goHome()
    {
        if let navigationController = navigationController
        {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    @objc func refreshArticles()
    {
        getFreshNewsArticles()
    }
    
    
    func showError(message: String)
    {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
}


extension ArticleTableViewController: NSFetchedResultsControllerDelegate
{
    fileprivate func setupArticleListFetchedResultsController()
    {
        // Create the fetch request
        let fetchRequest:NSFetchRequest<ArticleList> = ArticleList.fetchRequest()
        
        // Set up the predicate
        let countryCode = (category == "favorite" || category == "share") ? "n/a" : Settings.sharedInstance().getCountryCode()
        let predicate = NSPredicate(format: "categoryName = %@ AND countryCode = %@", category, countryCode)
        fetchRequest.predicate = predicate
        
        // Set up the sort order
        let sortDescriptor = NSSortDescriptor(key: "lastDownloaded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create the fetch results controller
        fetchedArticleListResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set up the delegate
        fetchedArticleListResultsController.delegate = self
        
        // Perform the fetch
        do
        {
            try fetchedArticleListResultsController.performFetch()
            
            if(fetchedArticleListResultsController.fetchedObjects?.count == 0)
            {
                if(articleList == nil)
                {
                    articleList = ArticleList(context: dataController.viewContext)
                    articleList.categoryName = category
                    articleList.countryCode = countryCode
                    
                    try? dataController.viewContext.save()
                }
            }
            else
            {
                articleList = fetchedArticleListResultsController.fetchedObjects![0]
            }
        }
        catch
        {
            fatalError("The Article fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    fileprivate func setupArticleFetchedResultsController()
    {
        // Create the fetch request
        let fetchRequest:NSFetchRequest<Article> = Article.fetchRequest()
        
        
        // Set up the predicate
        if(articleList != nil)
        {
            let predicate = NSPredicate(format: "articleList == %@", articleList)
            fetchRequest.predicate = predicate
        }
        // Set up the sort order
        let sortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create the fetch results controller
        fetchedArticleResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set up the delegate
        fetchedArticleResultsController.delegate = self
        
        // Perform the fetch
        do
        {
            try fetchedArticleResultsController.performFetch()
        }
        catch
        {
            fatalError("The Article fetch could not be performed: \(error.localizedDescription)")
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
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
                break
            case .delete:
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
                break
            case .update:
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
                break
            case .move:
                break
        }
    }
}

extension ArticleTableViewController
{
    func addSaveNotificationObserver()
    {
        removeSaveNotificationObserver()
        saveObserverToken = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: dataController?.viewContext, queue: nil, using: handleSaveNotification(notification:))
    }
    
    func removeSaveNotificationObserver()
    {
        if let token = saveObserverToken
        {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func handleSaveNotification(notification:Notification)
    {
        dataController.viewContext.perform
        {
            do
            {
                try self.fetchedArticleResultsController.performFetch()
            }
            catch
            {
                fatalError("The Article fetch could not be performed: \(error.localizedDescription)")
            }
        }
        
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
    }
}
