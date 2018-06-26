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
        self.category = "sports"
        self.performSegue(withIdentifier: "segueToArticleTable", sender: self)
    }
    
    @IBAction func buttonGeneralPressed(_ sender: Any)
    {
        self.category = "general"
        self.performSegue(withIdentifier: "segueToArticleTable", sender: self)
    }
    
    @IBAction func buttonBusinessPressed(_ sender: Any)
    {
        self.category = "business"
        self.performSegue(withIdentifier: "segueToArticleTable", sender: self)
    }
    
    @IBAction func buttonEntertainmentPressed(_ sender: Any)
    {
        self.category = "entertainment"
        self.performSegue(withIdentifier: "segueToArticleTable", sender: self)
    }
    
    @IBAction func buttonHealthPressed(_ sender: Any)
    {
        self.category = "health"
        self.performSegue(withIdentifier: "segueToArticleTable", sender: self)
    }
    
    @IBAction func buttonSciencePressed(_ sender: Any)
    {
        self.category = "science"
        self.performSegue(withIdentifier: "segueToArticleTable", sender: self)
    }
    
    @IBAction func buttonTechnologyPressed(_ sender: Any)
    {
        self.category = "technology"
        self.performSegue(withIdentifier: "segueToArticleTable", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "segueToArticleTable")
        {
            let controller: ArticleTableViewController = segue.destination as! ArticleTableViewController
        
        
            controller.category = self.category
        }
    }
}

