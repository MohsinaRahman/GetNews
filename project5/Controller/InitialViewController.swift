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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var hotNewsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var readingListButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func favoriteButtonPressed(_ sender: Any)
    {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ArticleTableViewController") as! ArticleTableViewController
        
        controller.category = "favorite"
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    
    
    
    @IBAction func hotNewsButtonPressed(_ sender: Any)
    {
        
    }
    
    @IBAction func shareButtonPressed(_ sender: Any)
    {
        
    }
    
    @IBAction func readingListButtonPressed(_ sender: Any)
    {
        
    }
  
    
}
