//
//  CitiesViewController.swift
//  RussianCities
//
//  Created by Михаил Андреичев on 17/11/2018.
//  Copyright © 2018 MichailAndreichev. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoContent: UILabel!
    
    var cities: [City]?
    var totalCount: Int = 0
    
    var isLoadingMore = false
    var loadingMoreOffset = 0
    static let NewOffsetValue = 30 //Смещение при подгрузке новой партии данных
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    var searchController: UISearchController!
    var searchText: String = ""
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        
        searchController.searchBar.barTintColor = ColorHelper.color(for: .lightGrayColor)
        //searchController.searchBar.tintColor = ColorHelper.color(for: .grayTextColor)
        //searchController.searchBar.backgroundColor = ColorHelper.color(for: .baseGrayColor)
        
        searchController.searchBar.layer.borderColor =          ColorHelper.color(for: .lightGrayColor).cgColor
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.backgroundImage = nil
        
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        //navigationItem.searchController = searchController
        
        let searchField = searchController.searchBar.value(forKey: "searchField") as! UITextField
        searchField.font = UIFont.systemFont(ofSize: 17)
        
        searchController.searchBar.setValue("Отмена", forKey: "_cancelButtonText")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        self.tableView.register(UINib(nibName: "CityCell", bundle: nil),
                                forCellReuseIdentifier: "CityCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .interactive
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self,
                                      action: #selector(loadCities),
                                      for: .valueChanged)
        
        labelNoContent.isHidden = true
        
        self.refreshControl.sendActions(for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc func loadCities() {
        if self.cities?.count ?? 0 == 0 {
            self.view.startShowingActivityIndicator()
        }
        self.labelNoContent.isHidden = true
        
        if !self.isLoadingMore {
            self.loadingMoreOffset = 0
        }
        
        CityService.loadCities(q: searchController.searchBar.text ?? "", offset: loadingMoreOffset) {
            result in
            
            self.view.stopShowingActivityIndicator()
            self.refreshControl.endRefreshing()
            
            if result.error != nil {
                self.labelNoContent.text = "Произошла ошибка сети. Проверьте подключение и повторите попытку."
                self.labelNoContent.isHidden = false
                self.cities?.removeAll()
                self.totalCount = 0
                self.tableView.reloadData()
                return
            }
            
            guard result.cities != nil else {
                self.labelNoContent.text = "Произошла ошибка."
                self.labelNoContent.isHidden = false
                self.cities?.removeAll()
                self.totalCount = 0
                self.tableView.reloadData()
                return
            }
            
            if self.isLoadingMore {
                self.cities?.append(contentsOf: result.cities!)
                self.tableView.removeActivityIndicatorFromFooter()
            } else {
                self.cities = result.cities
            }
            self.totalCount = result.сount
            self.isLoadingMore = false
            
            self.reloadTableView()
        }
    }
    
    func reloadTableView() {
        if self.cities?.count == 0 {
            labelNoContent.text = "Нет городов"
            labelNoContent.isHidden = false
        } else {
            labelNoContent.isHidden = true
        }
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.searchController.dismiss(animated: false, completion: nil)
        
        if let nextVc = segue.destination as? CityViewController {
            
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            nextVc.city = cities?[indexPath.row]
        }
    }
}

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        
        let city = cities?[indexPath.row]
        
        cell.cityName.text = city?.title
        cell.regionName.text = city?.region
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "CityInfo", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (cities?.count ?? 0) - 1
            && !isLoadingMore
            && self.cities?.count ?? 0 != self.totalCount {
            self.isLoadingMore = true
            
            loadingMoreOffset += CitiesViewController.NewOffsetValue
            self.tableView.addLoadingIndicatorToFooter()
            self.loadCities()
        }
    }
}

extension CitiesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if self.searchText != self.searchController.searchBar.text {
            self.loadingMoreOffset = 0
            self.searchText = self.searchController.searchBar.text ?? ""
            self.cities?.removeAll()
            self.tableView.reloadData()
            loadCities()
        }
    }
}
