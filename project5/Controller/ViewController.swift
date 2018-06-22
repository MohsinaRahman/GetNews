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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func buttonGeneralPressed(_ sender: Any)
    {
        NewsAPIClient.sharedInstance().getArticlesForCategory(category: "sports")
        {
            (_ success: Bool, _ articles: [Article]?, _ errorString: String?)->Void in
            
                if(success)
                {
                    print("success")
                }
                else
                {
                    print("failure")
                }
        }
        
    }
}

