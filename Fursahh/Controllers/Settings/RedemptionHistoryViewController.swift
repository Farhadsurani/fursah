//
//  RedemptionHistoryViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 14/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class RedemptionHistoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRecordFoundLabel: UILabel!
    
    var arrVouchers: [RedeemedVoucherModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getRedeemedVouchers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func getRedeemedVouchers() {
        Utility.showLoader()
        let params: [String: Any] = [
            "user_id": AppStateManager.shared.getUserId() ?? "",
        ]
        APIManager.sharedInstance.merchant.getRedeemedOffers(params: params, success: { (responseArray) in
            Utility.hideLoader()
            self.arrVouchers = Mapper<RedeemedVoucherModel>().mapArray(JSONArray: responseArray as! [[String : Any]])
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


extension RedemptionHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.arrVouchers?.count ?? 0
        self.noRecordFoundLabel.isHidden = count == 0 ? false: true
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferCellIdentifier", for: indexPath)
            as! OfferRedeemedViewCell
        
        cell.setData(self.arrVouchers![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
