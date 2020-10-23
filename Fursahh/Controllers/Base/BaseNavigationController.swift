//
//  BaseNavigationController.swift
//  SalamSquare
//
//  Created by Akber Sayni on 16/06/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.barTintColor = .white
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
