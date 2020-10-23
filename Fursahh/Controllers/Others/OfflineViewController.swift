//
//  OfflineViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 27/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {
	@IBOutlet weak var messageLabel: UILabel!
	
	let network = NetworkManager.sharedInstance
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.messageLabel.text = "You are offline, connect to the internet".localized
		
		network.reachability.whenReachable = { reachability in
			//self.showMainController()
			DispatchQueue.main.async {
				self.dismiss(animated: true, completion: nil)
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	private func showMainController() -> Void {
		DispatchQueue.main.async {
			//self.performSegue(withIdentifier: "MainController", sender: self)
		}
	}
	
	@IBAction func onBtnClose(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
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
