//
//  SearchViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper
import FacebookCore

class SearchViewController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.tableFooterView = UIView()
        }
    }
    
    var arrMerchants: [MerchantModel]?    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func logSearchEvent(contentType : String, contentData : String, contentId : String, searchString : String, success : Bool) {
        let params : AppEvent.ParametersDictionary = [
            .contentType : contentType,
            .content : contentData,
            .contentId : contentId,
            .searchedString : searchString,
            .successful : NSNumber(value: success ? 1 : 0)
        ]
        let event = AppEvent(name: .searched, parameters: params)
        AppEventsLogger.log(event)
    }
	
	@objc func reload() {
		self.searchMerchants(self.searchBar.text!)
	}
    
    @IBAction func onBtnSearchFilter(_ sender: AnyObject) {
        self.showSearchFilter()
    }
    
    // MARK: - Web API Methods
    
    private func searchMerchants(_ searchText: String) {
        let params: [String: Any] = [
            "merchant_name": searchText,
        ]
		self.activityIndicatorView.startAnimating()
        APIManager.sharedInstance.merchant.searchMerchants(params: params, success: { (response) in
			self.activityIndicatorView.stopAnimating()
            self.arrMerchants = Mapper<MerchantModel>().mapArray(JSONArray: response as! [[String : Any]])
            self.tableView.reloadData()
            
            self.logSearchEvent(contentType: "", contentData: "", contentId: "", searchString: searchText, success: true)
        }) { (error) in
			self.activityIndicatorView.stopAnimating()
            
            self.logSearchEvent(contentType: "", contentData: "", contentId: "", searchString: searchText, success: false)
        }
    }
	
    // MARK: - Navigation
    
    private func showSearchFilter() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchFiltersViewController") as! SearchFiltersViewController
        self.present(BaseNavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    private func showMerchantDetails(_ indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MerchantDetailsViewController") as! MerchantDetailsViewController
        controller.merchantId = self.arrMerchants![indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMerchants?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCellIdentifier", for: indexPath) as! SearchMerchantViewCell
		cell.setData(self.arrMerchants![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showMerchantDetails(indexPath)
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
}

extension SearchViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		guard !(searchBar.text!.isEmpty) else {
			NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
			self.arrMerchants?.removeAll()
			self.tableView.reloadData()
			return
		}
		
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
		self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		self.view.endEditing(true)
	}
}

