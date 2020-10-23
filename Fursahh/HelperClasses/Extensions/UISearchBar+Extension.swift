//
//  UISearchBar+Extension.swift
//  Fursahh
//
//  Created by Akber Sayni on 01/09/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
	private var textField: UITextField? {
		let subViews = self.subviews.flatMap { $0.subviews }
		return (subViews.filter { $0 is UITextField }).first as? UITextField
	}
	
	private var searchIcon: UIImage? {
		let subViews = subviews.flatMap { $0.subviews }
		return  ((subViews.filter { $0 is UIImageView }).first as? UIImageView)?.image
	}
	
	private var activityIndicator: UIActivityIndicatorView? {
		return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
	}
	
	var isLoading: Bool {
		get {
			return activityIndicator != nil
		} set {
			if newValue {
				if activityIndicator == nil {
					var style: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.gray
					var backgroundColor: UIColor = UIColor.clear
					if #available(iOS 11.0, *) {
						style = UIActivityIndicatorView.Style.gray
						backgroundColor = UIColor.clear
					}
					
					let _activityIndicator = UIActivityIndicatorView(style: style)
					_activityIndicator.startAnimating()
					_activityIndicator.backgroundColor = backgroundColor
					
					if #available(iOS 11.0, *) {
						self.setImage(UIImage(), for: .search, state: .normal)
					}
					
					textField?.leftView?.addSubview(_activityIndicator)
					let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
					_activityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
				}
			} else {
				if #available(iOS 11.0, *) {
					let _searchIcon = searchIcon
					self.setImage(_searchIcon, for: .search, state: .normal)
				}
				activityIndicator?.removeFromSuperview()
			}
		}
	}}
