//
//  ViewController.swift
//  project5
//
//  Created by mohsina rahman on 5/31/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var buttonGeneral: UIButton!
    @IBOutlet weak var buttonSports: UIButton!
    
    var category: String = "general"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let controller: ArticleTableViewController = segue.destination as! ArticleTableViewController
        
        
        controller.category = self.category
    }
}

