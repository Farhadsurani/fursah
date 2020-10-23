//
//  FavoriteMerchantsViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class FavoriteMerchantsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRecordFoundLabel: UILabel!
    
    var arrMerchants = Array<MerchantModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getFavoriteMerchants()
    }
    
    @IBAction func onBtnRemoveFavorite(_ sender: UIButton) {
        if let indexPath = Utility.getIndexPathForRow(self.tableView, sender: sender) {
            self.removeMerchantFavorite(self.arrMerchants[indexPath.row], indexPath: indexPath)
        }
    }
    
    // MARK: - Web API Methods
    
    private func getFavoriteMerchants() {
        Utility.showLoader()
        let params: [String: Any] = [
            "user_id": AppStateManager.shared.getUserId() ?? ""
        ]
        APIManager.sharedInstance.merchant.getFavoriteMerchants(params: params, success: { (response) in
            Utility.hideLoader()
            let array = Mapper<MerchantModel>().mapArray(JSONArray: response as! [[String : Any]])
            self.arrMerchants = array
            self.tableView.reloadData()
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func removeMerchantFavorite(_ merchant: MerchantModel?, indexPath: IndexPath) {
        Utility.showLoader()
        let params: [String: Any] = [
            "user_id": AppStateManager.shared.getUserId() ?? "",
            "merchant_id": merchant?.id ?? "",
            "is_favorite": "0"
        ]
        APIManager.sharedInstance.merchant.addMerchantFavorite(params: params, success: { (success) in
            Utility.hideLoader()
            Utility.showMessageAlert(message: "merchant_removed_success".localized, closure: { (action) in
                self.arrMerchants.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })            
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }

    // MARK: - Navigation
    
    private func showMerchantDetails(_ indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MerchantDetailsViewController")
            as! MerchantDetailsViewController
                
        controller.merchantId = self.arrMerchants[indexPath.row].id
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension FavoriteMerchantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.noRecordFoundLabel.isHidden = self.arrMerchants.count == 0 ? false : true
        return self.arrMerchants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantListCellIdentifier", for: indexPath)
            as! MerchantListViewCell
        
        cell.setData(self.arrMerchants[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showMerchantDetails(indexPath)
    }
}
