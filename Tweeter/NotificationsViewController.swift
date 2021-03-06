//
//  NotificationsViewController.swift
//  Tweeter
//
//  Created by William Huang on 2/24/17.
//  Copyright © 2017 William Huang. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBarButtons() {
        let connectImage = UIImage(named: "addfriend-icon")
        let composeImage = UIImage(named: "edit-icon")
        
        let connectButton = UIBarButtonItem(image: connectImage, style: .plain, target: self, action: nil)
        let composeButton = UIBarButtonItem(image: composeImage, style: .plain, target: self, action: nil)
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: nil)
        searchButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -44)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 64/255, green: 153/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItems = [composeButton, searchButton]
        self.navigationItem.title = "Notifications"
        self.navigationItem.leftBarButtonItem = connectButton
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
