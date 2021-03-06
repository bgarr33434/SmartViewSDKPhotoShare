//
//  DeviceListController.swift
//  PhotoShare
//
//  Created by Amit Khoth on 5/2/16.
//  Copyright © 2016 Samsung. All rights reserved.
//

import UIKit
import SmartView
class DeviceListController: UITableViewController {
    var didFindServiceObserver: AnyObject? = nil
    
    var didRemoveServiceObserver: AnyObject? = nil

   
    @IBOutlet var mtableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:"DeviceNameCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        didFindServiceObserver =  PhotoShareController.sharedInstance.search.on(MSDidFindService) { [unowned self] notification in
            self.tableView.reloadData()
        }
        didRemoveServiceObserver = PhotoShareController.sharedInstance.search.on(MSDidRemoveService) {[unowned self] notification in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        PhotoShareController.sharedInstance.search.off(didFindServiceObserver!)
        PhotoShareController.sharedInstance.search.off(didRemoveServiceObserver!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if PhotoShareController.sharedInstance.search.isSearching {
            return PhotoShareController.sharedInstance.services.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceNameCell", for: indexPath)
        
        
        
        cell.textLabel!.text = PhotoShareController.sharedInstance.services[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if PhotoShareController.sharedInstance.search.isSearching {
            let service = PhotoShareController.sharedInstance.services[indexPath.row] as Service
            
            PhotoShareController.sharedInstance.selectedService = service
            PhotoShareController.sharedInstance.connect(service)
        }
        dismiss(animated: true) { }
    }

}
