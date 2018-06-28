//
//  SharedArticleViewController.swift
//  project5
//
//  Created by mohsina rahman on 6/26/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import CoreData

class SharedArticleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var dataController:DataController!
    var fetchedSharedArticleResultsController:NSFetchedResultsController<SharedArticle>!
    
    let minimimRowHeight:CGFloat = 128.0
    let placeHolderImage = UIImage(named: "no_image_available")

    @IBOutlet weak var sharedArticleTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       sharedArticleTableView.rowHeight = UITableViewAutomaticDimension
        
        let buttonHome = UIBarButtonItem(image: #imageLiteral(resourceName: "home_1"), style: .plain, target: self, action: #selector(goHome))
        navigationItem.rightBarButtonItems = [buttonHome]
        
        navigationItem.title = "Shared List"
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        setupSharedArticleFetchedResultsController()
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let fetchedResults = fetchedSharedArticleResultsController.fetchedObjects!.count
        
        return max(fetchedResults, 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharedArticleCell")! as! SharedArticleTableViewCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        
        let article = fetchedSharedArticleResultsController.object(at: indexPath).article!
        
        // Set the headline
        cell.sharedArticleHeadlineLabel.text = article.title
        // Set the source
        cell.sharedArticleSourceLabel.text = article.sourceName
        // Set the image
        if(article.imageData == nil)
        {
            cell.sharedArticleImageView.image = placeHolderImage
        }
        else
        {
            cell.sharedArticleImageView.image = UIImage(data: article.imageData!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ArticleDisplayViewController") as! ArticleDisplayViewController
        
        controller.dataController = dataController
        controller.article = fetchedSharedArticleResultsController.object(at: indexPath).article!
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return minimimRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return max(minimimRowHeight, UITableViewAutomaticDimension)
    }
    
    @objc func goHome()
    {
        if let navigationController = navigationController
        {
            navigationController.popToRootViewController(animated: true)
        }
    }

}


extension SharedArticleViewController: NSFetchedResultsControllerDelegate
{
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
                    self.sharedArticleTableView.reloadData()
                }
                break
            case .delete:
                print("Delete Operation")
                DispatchQueue.main.async
                {
                    self.sharedArticleTableView.reloadData()
                }
                break
            case .update:
                print("Update Operation")
                DispatchQueue.main.async
                {
                    self.sharedArticleTableView.reloadData()
                }
                break
            case .move:
                print("Move Operation")
                DispatchQueue.main.async
                {
                    self.sharedArticleTableView.reloadData()
                }
                break
            }
    }
}
