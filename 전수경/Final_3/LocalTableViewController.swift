//
//  LocalTableViewController.swift
//  Final_3
//
//  Created by SWUCOMPUTER on 2018. 5. 28..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class LocalTableViewController: UITableViewController {

    var local: [String] = ["종로구", "용산구", "광진구", "중랑구", "강북구", "노원구", "서대문구", "양천구", "구로구", "영등포구", "관악구", "강남구", "강동구", "송파구", "서초구", "동작구", "금천구", "강서구", "마포구", "은평구", "도봉구", "성북구", "동대문구", "성동구", "중구"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "서울시"
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return local.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Local Cell", for: indexPath)

        // Configure the cell...
        local.sort()
        var localName = Array(local)
        cell.textLabel?.text = localName[indexPath.row]

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toCafeView" {
            if let destVC = segue.destination as? CafeTableViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    let localT: String = Array(local) [selectedIndex]
                    destVC.dAddress = "서울시 " + localT
                    destVC.title = localT
                }
            }
        }
    }

}
