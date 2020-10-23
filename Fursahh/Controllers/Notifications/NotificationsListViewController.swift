//
//  NotificationsListViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationsListViewController: BaseViewController {
    @IBOutlet weak var noRecordFoundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var arrNotifications: [NotificationModel]?    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserNotifications()
    }
    
    private func getUserNotifications() {
        Utility.showLoader()
        let params: [String: Any] = [
            "user_id": AppStateManager.shared.getUserId() ?? ""
        ]
        APIManager.sharedInstance.user.getUserNotifications(params: params, success: { (responseArray) in
            Utility.hideLoader()
            self.arrNotifications = Mapper<NotificationModel>().mapArray(JSONArray: responseArray as! [[String : Any]])
            self.tableView.reloadData()
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
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

extension NotificationsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.arrNotifications?.count ?? 0
        self.noRecordFoundLabel.isHidden = count == 0 ? false : true
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCellIdentifier", for: indexPath)
            as! NotificationListViewCell
        
        cell.setData(self.arrNotifications![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            Utility.showAlert(title: "Message", message: self.arrNotifications![indexPath.row].message)
        }
    }
}
