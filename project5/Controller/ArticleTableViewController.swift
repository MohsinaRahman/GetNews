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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(category)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell")!
        return cell
    }

}
