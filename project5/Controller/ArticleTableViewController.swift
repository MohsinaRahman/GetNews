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
        
        
        return cell
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
