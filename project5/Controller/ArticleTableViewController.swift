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
    var sharedArticle : Article?

    
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
            case "share":
                self.navigationItem.title = "Shared List"
            default:
                self.navigationItem.title = "Other Headlines"
        }
        
        if(category == "favorite")
        {
            self.articlesArray = ArticleDataSource.sharedInstance().articleFavoriteArray
        }
        else if(category == "share")
        {
            self.articlesArray = ArticleDataSource.sharedInstance().articleSharedArray
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
                        print("Error code: \(errorString!)")
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
        let shareAction = self.contextForShareAction(forRowAtIndexPath: indexPath)
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [shareAction])
        
        return swipeConfig
    }
    
    func contextForShareAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction
    {
        sharedArticle = articlesArray![indexPath.row]
    
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
            if(ArticleDataSource.sharedInstance().articleSharedArray == nil)
            {
                ArticleDataSource.sharedInstance().articleSharedArray = [sharedArticle!]
            }
            else
            {
                ArticleDataSource.sharedInstance().articleSharedArray?.append(sharedArticle!)
            }
        }
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
