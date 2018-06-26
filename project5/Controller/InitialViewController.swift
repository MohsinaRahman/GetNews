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
    @IBOutlet weak var topicsearchButton: UIButton!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func favoriteButtonPressed(_ sender: Any)
    {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ArticleTableViewController") as! ArticleTableViewController
        
        controller.dataController = dataController
        controller.category = "favorite"
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func hotNewsButtonPressed(_ sender: Any)
    {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "NewsCategoryViewController") as! NewsCategoryViewController
        
        controller.dataController = dataController
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func topicSearchbuttonPressed(_ sender: Any)
    {
        print("Reading list pressed")
    }
    
    @IBAction func shareButtonPressed(_ sender: Any)
    {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ArticleTableViewController") as! ArticleTableViewController
        
        controller.category = "share"
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any)
    {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.navigationController!.pushViewController(controller, animated: true)
    }

}
