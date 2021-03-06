//
//  InitialViewController.swift
//  project5
//
//  Created by mohsina rahman on 6/23/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController
{
    var dataController:DataController!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var hotNewsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        hotNewsButton.imageView?.contentMode = .scaleAspectFit
        shareButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.imageView?.contentMode = .scaleAspectFit
    }

    @IBAction func favoriteButtonPressed(_ sender: Any)
    {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ArticleTableViewController") as! ArticleTableViewController
        
        controller.dataController = dataController
        controller.category = "favorite"
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func hotNewsButtonPressed(_ sender: Any)
    {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NewsCategoryViewController") as! NewsCategoryViewController
        
        controller.dataController = dataController
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func topicSearchbuttonPressed(_ sender: Any)
    {

    }
    
    @IBAction func shareButtonPressed(_ sender: Any)
    {
        let controller = storyboard!.instantiateViewController(withIdentifier: "SharedArticleViewController") as! SharedArticleViewController
        
        controller.dataController = dataController
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any)
    {
        let controller = storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        navigationController!.pushViewController(controller, animated: true)
    }

}
