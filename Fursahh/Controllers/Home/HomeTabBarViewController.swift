//
//  HomeTabBarViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 07/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appearance = UITabBarItem.appearance(whenContainedInInstancesOf: [HomeTabBarViewController.self])
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColors.redColor], for: .selected)
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
