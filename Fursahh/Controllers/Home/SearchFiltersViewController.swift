//
//  SearchFiltersViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 18/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper
import TagListView

protocol SearchFilterViewDelegate {
    func didSelectFilterAttributes(_ selectedItem: [AttributeModel])
}

class SearchFiltersViewController: BaseViewController {
	@IBOutlet weak var backBarItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.tableFooterView = UIView()
        }
    }
    
    var arrCuisines = Array<AttributeModel>()
    var arrAmenities = Array<AttributeModel>()
	var arrFilters = Array<AttributeModel>()
	
    var selectedItems = [AttributeModel]()
    var delegate: SearchFilterViewDelegate?
    
    var categoryId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.updateLocalizeUI()
        self.getSearchAttributes()
    }
	
	private func updateLocalizeUI() {
		if Locale.current.languageCode == "ar" {
			var backImage = self.backBarItem.image
			backImage = backImage?.imageFlippedForRightToLeftLayoutDirection()
			
			self.backBarItem.image = backImage
		}
	}
    
    private func updateTagListView() {
        // Remove all tags
        self.tagListView.removeAllTags()

        // Add tags list from selected items
		if Locale.current.languageCode == "ar" {
			let datasource = self.selectedItems.map { $0.nameAR ?? "" }
			self.tagListView.addTags(datasource)
		} else {
			let datasource = self.selectedItems.map { $0.name ?? "" }
			self.tagListView.addTags(datasource)
		}
		
        // Hide/Show TagListView
        self.heightConstraint.constant = (selectedItems.count > 0) ? 44 : 0
    }
    
    private func updateSelectedItems(_ item: AttributeModel) {
        let results = selectedItems.filter { $0.id == item.id }
        if results.isEmpty {
            self.selectedItems.append(item)
        } else {
            if let index = self.selectedItems.firstIndex(of: item) {
                self.selectedItems.remove(at: index)
            }
        }
    }
    
    @IBAction func onBtnDone(_ sender: AnyObject) {
        self.dismiss(animated: true) {
            guard self.delegate != nil else { return }
            self.delegate?.didSelectFilterAttributes(self.selectedItems)
        }
    }
    
    // MARK: - Web API Methods
    
    private func getSearchAttributes() {
        Utility.showLoader()
        let params: [String: Any] = [
            "cat_id": self.categoryId ?? ""
        ]
        APIManager.sharedInstance.merchant.getSearchAttributes(params: params, success: { (response) in
            Utility.hideLoader()
			
			// Add cuisines items
            if let cuisines = response["cuisines"] as? Array<[String: AnyObject]> {
                self.arrCuisines = Mapper<AttributeModel>().mapArray(JSONArray: cuisines)
            }
			
            // Add amenities items
            if let ammenities = response["amenities"] as? Array<[String: AnyObject]> {
                self.arrAmenities = Mapper<AttributeModel>().mapArray(JSONArray: ammenities)
            }

			// Add amenities items
			if let filters = response["filters"] as? Array<[String: AnyObject]> {
				self.arrFilters = Mapper<AttributeModel>().mapArray(JSONArray: filters)
			}
			
            self.updateTagListView()
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

extension SearchFiltersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.arrCuisines.count
        case 1:
            return self.arrAmenities.count
		default:
			return self.arrFilters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFilterCellIdentifier", for: indexPath)
            as! SearchFilterViewCell
        
        switch indexPath.section {
        case 0:
            cell.setData(self.arrCuisines[indexPath.row], selectedItems: selectedItems)
            break
        case 1:
            cell.setData(self.arrAmenities[indexPath.row], selectedItems: selectedItems)
            break
		default:
			cell.setData(self.arrFilters[indexPath.row], selectedItems: selectedItems)
			break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            let item = self.arrCuisines[indexPath.row]
            self.updateSelectedItems(item)
            break
        case 1:
            let item = self.arrAmenities[indexPath.row]
            self.updateSelectedItems(item)
            break
		default:
			let item = self.arrFilters[indexPath.row]
			self.updateSelectedItems(item)
			break
        }
        
        self.updateTagListView()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch section {
		case 0:
			return (self.arrCuisines.count > 0) ? 40.0 : 0.0
		case 1:
			return (self.arrAmenities.count > 0) ? 40.0 : 0.0
		default:
			return (self.arrFilters.count > 0) ? 40.0 : 0.0
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40.0))
		view.backgroundColor = AppColors.redColor
		
		let label = UILabel(frame: CGRect(x: 20.0, y: 0, width: view.frame.size.width - 40.0, height: view.frame.size.height))
		label.font = UIFont.boldSystemFont(ofSize: 12.0)
		label.textColor = .white

		switch section {
		case 0:
			label.text = "Popular Cuisines".localized
		case 1:
			label.text = "Amenities".localized
		default:
			label.text = "Filters".localized
		}
		
		view.addSubview(label)
		
		return view
	}
}

extension SearchFiltersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension SearchFiltersViewController: TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if let index = sender.tagViews.firstIndex(of: tagView), index < selectedItems.count {
            //sender.removeTagView(tagView)
            
            let item = self.selectedItems[index]
//            item.isSelected = !item.isSelected
            self.updateSelectedItems(item)
            
            self.updateTagListView()
            self.tableView.reloadData()
        }
    }
}

