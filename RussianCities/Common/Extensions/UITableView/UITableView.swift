//
//  UITableView.swift
//  RussianCities
//
//  Created by Михаил Андреичев on 18/11/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func addLoadingIndicatorToFooter() {

        let footerView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: self.frame.width,
                                                         height: 40))
        self.tableFooterView = footerView
        footerView.startShowingActivityIndicator()
    }
    
    func removeActivityIndicatorFromFooter() {
        self.tableFooterView = UIView()
    }
}
