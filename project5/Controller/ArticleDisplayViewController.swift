//
//  ArticleDisplayViewController.swift
//  project5
//
//  Created by mohsina rahman on 6/23/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import WebKit

class ArticleDisplayViewController: UIViewController
{

    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String?
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadURL()
    }
    
    func loadURL()
    {
        if(urlString != nil)
        {
            let url = URL(string:urlString!)
            let request = URLRequest(url:url!)
            webView.load(request)
        }
    }


}
