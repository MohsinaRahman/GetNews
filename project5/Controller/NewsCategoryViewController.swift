//
//  ViewController.swift
//  project5
//
//  Created by mohsina rahman on 5/31/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit

class NewsCategoryViewController: UIViewController
{
    var dataController:DataController!
    
    @IBOutlet weak var buttonGeneral: UIButton!
    @IBOutlet weak var buttonSports: UIButton!
    @IBOutlet weak var buttonBusiness: UIButton!
    @IBOutlet weak var buttonEntertainment: UIButton!
    @IBOutlet weak var buttonHealth: UIButton!
    @IBOutlet weak var buttonScience: UIButton!
    @IBOutlet weak var buttonTechnology: UIButton!
    
    var category: String = "general"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        buttonGeneral.imageView?.contentMode = .scaleAspectFit
        buttonSports.imageView?.contentMode = .scaleAspectFit
        buttonBusiness.imageView?.contentMode = .scaleAspectFit
        buttonEntertainment.imageView?.contentMode = .scaleAspectFit
        buttonHealth.imageView?.contentMode = .scaleAspectFit
        buttonScience.imageView?.contentMode = .scaleAspectFit
        buttonTechnology.imageView?.contentMode = .scaleAspectFit
    }
    

    @IBAction func buttonSportsPressed(_ sender: Any)
    {
        transitionToArticleTable(category: "sports")
    }
    
    @IBAction func buttonGeneralPressed(_ sender: Any)
    {
        transitionToArticleTable(category: "general")
    }
    
    @IBAction func buttonBusinessPressed(_ sender: Any)
    {
        transitionToArticleTable(category: "business")
    }
    
    @IBAction func buttonEntertainmentPressed(_ sender: Any)
    {
        transitionToArticleTable(category: "entertainment")

    }
    
    @IBAction func buttonHealthPressed(_ sender: Any)
    {
        transitionToArticleTable(category: "health")
    }
    
    @IBAction func buttonSciencePressed(_ sender: Any)
    {
        transitionToArticleTable(category: "science")
    }
    
    @IBAction func buttonTechnologyPressed(_ sender: Any)
    {
        transitionToArticleTable(category: "technology")
    }
    
    
    func transitionToArticleTable(category: String)
    {
        self.category = category
        self.performSegue(withIdentifier: "segueToArticleTable", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "segueToArticleTable")
        {
            let controller: ArticleTableViewController = segue.destination as! ArticleTableViewController
            
            controller.category = self.category
            controller.dataController = self.dataController
        }
    }
}

