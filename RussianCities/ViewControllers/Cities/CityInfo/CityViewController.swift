//
//  CityViewController.swift
//  RussianCities
//
//  Created by Михаил Андреичев on 17/11/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewRegion: UIView!
    @IBOutlet weak var labelRegion: UILabel!
    @IBOutlet weak var viewArea: UIView!
    @IBOutlet weak var labelArea: UILabel!
    
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = city?.title
        labelName.text = city?.title
        
        if let area = city?.area {
            labelArea.text = area
        } else {
            viewArea.isHidden = true
        }
        
        if let region = city?.region {
            labelRegion.text = region
        } else {
            viewRegion.isHidden = true
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
