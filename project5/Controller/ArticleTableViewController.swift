//
//  ArticleListViewController.swift
//  project5
//
//  Created by mohsina rahman on 6/21/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit

class ArticleTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var category:String = ""
    var articlesArray : [Article]?

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        switch(category)
        {
            case "general":
                self.navigationItem.title = "General Headlines"
            case "health":
                self.navigationItem.title = "Health Headlines"
            case "business":
                self.navigationItem.title = "Business Headlines"
            case "science":
                self.navigationItem.title = "Science Headlines"
            case "sports":
                self.navigationItem.title = "Sports Headlines"
            case "technology":
                self.navigationItem.title = "Technology Headlines"
            case "entertainment":
                self.navigationItem.title = "Entertainment Headlines"
            
        
            case "favorite":
                self.navigationItem.title = "Favorite List"
            default:
                self.navigationItem.title = "Other Headlines"
        }
        
        if(category == "favorite")
        {
            self.articlesArray = ArticleDataSource.sharedInstance().articleFavoriteArray
        }
        else
        {
            NewsAPIClient.sharedInstance().getArticlesForCategory(category: self.category)
            {
                (_ success: Bool, _ articles: [Article]?, _ errorString: String?)->Void in
                
                    if(success)
                    {
                        self.articlesArray = articles
                        
                        DispatchQueue.main.async
                        {
                            self.tableView.reloadData()
                        }
                    }
                    else
                    {
                        print("failure")
                    }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return articlesArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell")! as! ArticleTableViewCell
        
        // cell.textLabel?.text = articlesArray![indexPath.row].title
        cell.articleTitleTextView.text = articlesArray![indexPath.row].title
        cell.articleSourceTextView.text = articlesArray![indexPath.row].sourceName
        
        if(articlesArray![indexPath.row].imageData == nil)
        {
            cell.articleImageView.image = UIImage(named: "No image available")
            if(articlesArray![indexPath.row].urlToImage != nil)
            {
                NewsAPIClient.sharedInstance().getImageFromUrl(urlString: articlesArray![indexPath.row].urlToImage!)
                {
                    (_ success: Bool, _ imagePath: String?, _ imageData: Data?, _ errorString: String?)->Void in
                    
                    if(success)
                    {
                        self.articlesArray![indexPath.row].imageData = imageData
                        DispatchQueue.main.async
                            {
                                self.tableView.reloadRows(at: [indexPath], with: .bottom)
                        }
                    }
                    else
                    {
                        
                        print("Error downloading image: \(self.articlesArray![indexPath.row].urlToImage!)")
                        print("Error code: \(errorString)")
                    }
                }
            }
        }
        else
        {
            cell.articleImageView.image = UIImage(data: articlesArray![indexPath.row].imageData!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ArticleDisplayViewController") as! ArticleDisplayViewController
        
        controller.urlString = articlesArray![indexPath.row].url
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let markForReadingAction = self.contextualMarkForReadAction(forRowAtIndexPath: indexPath)
        let favoriteAction = self.contextualToggleFavoriteAction(forRowAtIndexPath: indexPath)
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [markForReadingAction, favoriteAction])
        
        return swipeConfig
    }
    
    func contextualMarkForReadAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction
    {
    
        var article = articlesArray![indexPath.row]
    
        let action = UIContextualAction(style: .normal,title: "Mark for Read")
        {
            (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
           
            completionHandler(true)
            
        }
        action.backgroundColor = UIColor.orange
        
        return action
    }
    
    func contextualToggleFavoriteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction
    {
        var article = articlesArray![indexPath.row]
        let action = UIContextualAction(style: .normal,title: "Favorite")
        {
            (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            if (ArticleDataSource.sharedInstance().articleFavoriteArray == nil)
            {
                ArticleDataSource.sharedInstance().articleFavoriteArray = [article]
            }
            else
            {
                ArticleDataSource.sharedInstance().articleFavoriteArray?.append(article)
            }
            completionHandler(true)
            
        }
        action.image = UIImage(named: "favorites")
        action.backgroundColor = UIColor.blue
        
        return action
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete)
        {
            articlesArray?.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
