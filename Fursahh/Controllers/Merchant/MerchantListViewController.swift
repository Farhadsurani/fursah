//
//  MerchantListViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper
import TagListView
import ESPullToRefresh
import FacebookCore

class MerchantListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var attributesCountView: UIView!
    @IBOutlet weak var attributesCountLabel: UILabel!
    @IBOutlet weak var noRecordFoundLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var tagListHeightConstraint: NSLayoutConstraint!

    var category: CategoryModel?
    var arrMerchants = Array<MerchantModel>()
    var arrFilterMerchants = Array<MerchantModel>()
    
    var selectedFilterItems: [AttributeModel]?
	
	let network = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNavigationTitle()
		self.setFilterButtonHidden()
		
		self.network.reachability.whenUnreachable = { [weak self] reachability in
            self?.showOfflineViewController()
		}
		
		self.network.reachability.whenReachable = { [weak self] reachability in
            self?.loadData()
		}

		self.tableView.es.addPullToRefresh {
			[unowned self] in
			/// Do anything you want...
			self.loadData()
			/// Stop refresh when your job finished, it will reset refresh footer if completion is true
			//self.tableView.es.stopPullToRefresh()
			/// Set ignore footer or not
			//self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
		}
		
		self.loadData()
        self.logViewContentEvent(contentType: "category", contentData: self.category?.name ?? "", contentId: "", currency: "OMR", price: 0.0)
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	private func loadData() {
		if let attributes = self.selectedFilterItems, attributes.count > 0 {
			self.searchMerchantsWithAttributes(attributes)
		} else {
			self.getMerchantList()
		}
	}
    
    private func setNavigationTitle() {
        let title = "Merchants".localized
        
        if Locale.current.languageCode == "ar" {
            self.navigationItem.title = self.category?.nameAR ?? title
        } else {
            self.navigationItem.title = self.category?.name ?? title
        }
    }
	
	private func setFilterButtonHidden() {
		if let category = self.category, category.id == "16" {
			self.filterButton.isHidden = false
		} else {
			self.filterButton.isHidden = true
		}
	}
    
    private func updateTagListView(_ items: [AttributeModel]) {
        self.tagListView.removeAllTags()
		
		if Locale.current.languageCode == "ar" {
			let datasource = items.map { $0.nameAR ?? "" }
			self.tagListView.addTags(datasource)
		} else {
			let datasource = items.map { $0.name ?? "" }
			self.tagListView.addTags(datasource)
		}
    }
    
    private func updateSearchFilterAttributesUI(_ items: [AttributeModel]) {
        self.updateTagListView(items)
        
        self.attributesCountLabel.text = "\(items.count)"
        self.attributesCountView.isHidden = (items.count == 0) ? true : false
        self.tagListHeightConstraint.constant = (items.count > 0) ? 44 : 0
    }
    
    private func logViewContentEvent(contentType : String, contentData : String, contentId : String, currency : String, price : Double) {
        let params : AppEvent.ParametersDictionary = [
            .contentType : contentType,
            .content : contentData,
            .contentId : contentId,
            .currency : currency
        ]
        let event = AppEvent(name: .viewedContent, parameters: params, valueToSum: price)
        AppEventsLogger.log(event)
    }
    
    @IBAction func onBtnSearchFilter(_ sender: AnyObject) {
        self.showSearchFilter()
    }
    
    // MARK: - Web API Methods
    
    private func getMerchantList() {
        Utility.showLoader()
        let params: [String: Any] = [
            "merchant_type": self.category?.id ?? "0",
            "lat": Constants.APP_DELEGATE.location?.coordinate.latitude ?? 0.0,
            "long": Constants.APP_DELEGATE.location?.coordinate.longitude ?? 0.0
        ]
        APIManager.sharedInstance.merchant.getMerchantList(params: params, success: { (response) in
            Utility.hideLoader()
			self.tableView.es.stopPullToRefresh()
            let array = Mapper<MerchantModel>().mapArray(JSONArray: response as! [[String : Any]])
            self.arrMerchants = array
            self.arrFilterMerchants = self.arrMerchants
            self.tableView.reloadData()
        }) { (error) in
            Utility.hideLoader()
			self.tableView.es.stopPullToRefresh()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func searchMerchantsWithAttributes(_ attributes: [AttributeModel]) {
        let attributes = attributes.map { $0.id ?? "0" }.joined(separator: ",")
        Utility.showLoader()
        let params: [String: Any] = [
            "cat_id": self.category?.id ?? "0",
            "attribute": attributes
        ]
        APIManager.sharedInstance.merchant.searchMerchantWithAttributes(params: params, success: { (response) in
            Utility.hideLoader()
			self.tableView.es.stopPullToRefresh()
            let array = Mapper<MerchantModel>().mapArray(JSONArray: response as! [[String : Any]])
            self.arrMerchants = array
            self.arrFilterMerchants = self.arrMerchants
            self.tableView.reloadData()
        }) { (error) in
            Utility.hideLoader()
			self.tableView.es.stopPullToRefresh()
            //Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    
    private func showMerchantDetails(_ indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MerchantDetailsViewController") as! MerchantDetailsViewController
        controller.merchantId = self.arrFilterMerchants[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showSearchFilter() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchFiltersViewController") as! SearchFiltersViewController
        controller.delegate = self
        controller.categoryId = self.category?.id
        if let selectedItems = self.selectedFilterItems, selectedItems.count > 0 {
            controller.selectedItems = selectedItems
        }
        self.present(BaseNavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension MerchantListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.noRecordFoundLabel.isHidden = self.arrFilterMerchants.count == 0 ? false : true
        
        return self.arrFilterMerchants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantListCellIdentifier", for: indexPath)
            as! MerchantListViewCell
        
        cell.setData(self.arrFilterMerchants[indexPath.row])
        
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

extension MerchantListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.arrFilterMerchants = self.arrMerchants.filter({ merchant -> Bool in
            if searchText.isEmpty { return true }
            return merchant.name?.lowercased().contains(searchText.lowercased()) ?? merchant.nameAR?.lowercased().contains(searchText.lowercased()) ?? false
        })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MerchantListViewController: SearchFilterViewDelegate {
    func didSelectFilterAttributes(_ selectedItems: [AttributeModel]) {
		guard selectedItems.count > 0 else { return }
		
        self.selectedFilterItems = selectedItems
        
        // Clear merchant list
        self.arrMerchants.removeAll()
        self.arrFilterMerchants.removeAll()
        self.tableView.reloadData()
        
        // Update search filter attributes UI
        self.updateSearchFilterAttributesUI(selectedItems)
        
        // Search merchant with attributes
        self.searchMerchantsWithAttributes(selectedItems)
    }
}

// MARK: - TagListViewDelegate
extension MerchantListViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("tag pressed")
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if let index = sender.tagViews.firstIndex(of: tagView), index < self.selectedFilterItems!.count {
            // Remove from filter items
            self.selectedFilterItems?.remove(at: index)

            // Update search filter attributes UI
            self.updateSearchFilterAttributesUI(selectedFilterItems!)
            
            if selectedFilterItems!.count == 0 {
                self.getMerchantList()
            } else {
                // Search merchant with attributes
                self.searchMerchantsWithAttributes(selectedFilterItems!)
            }
        }
    }
}
