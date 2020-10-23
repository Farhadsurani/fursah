//
//  SplashViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 30/06/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import Hero

class SplashViewController: UIViewController {
    @IBOutlet weak var loadingImageView: UIImageView!
    
    var arrLoadingImages: [UIImage] = [UIImage(named: "Loading1")!,
                                       UIImage(named: "Loading2")!,
                                       UIImage(named: "Loading3")!]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setLoadingAnimation()
        self.perform(#selector(didFinishTimeOut), with: nil, afterDelay: 3.0)
    }
    
    private func setLoadingAnimation() {
        self.loadingImageView.animationImages = self.arrLoadingImages
        self.loadingImageView.animationDuration = 3.0
        self.loadingImageView.animationRepeatCount = 0
        
        self.loadingImageView.startAnimating()
    }

    @objc private func didFinishTimeOut() {
        self.loadingImageView.stopAnimating()

        if AppStateManager.shared.isUserLoggedIn() {
            Constants.APP_DELEGATE.loadHomeViewController()
        } else {
            self.showTutorialViewController()
        }
    }
    
    // MARK: - Navigation
    
    private func showLoginViewController() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            as! LoginViewController
        
        controller.hero.isEnabled = true
        controller.hero.modalAnimationType = .auto
        
        self.heroReplaceViewController(with: controller)
    }

    private func showTutorialViewController() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController")
            as! TutorialViewController
        
        controller.hero.isEnabled = true
        controller.hero.modalAnimationType = .slide(direction: .up)
        
        self.heroReplaceViewController(with: controller)
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
