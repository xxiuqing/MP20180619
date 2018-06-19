//
//  FavoriteTableViewController.swift
//  Final_3
//
//  Created by SWUCOMPUTER on 2018. 6. 10..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    var fetchedArray: [FavoriteData] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let name = appDelegate.userName {
            self.title = name + "님의 관심 카페"
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = []
        self.downloadDataFromServer()
    }
    
    func downloadDataFromServer() -> Void {
        let urlString: String = "http://condi.swu.ac.kr/student/T11iphone/favorite/favoriteTable.php"
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return;
            }
            let response = response as! HTTPURLResponse
            
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return; }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData, options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: FavoriteData = FavoriteData()
                        var jsonElement = jsonData[i]
                        newData.favNo = jsonElement["favoriteNo"] as! String
                        newData.name = jsonElement["name"] as! String
                        newData.address = jsonElement["address"] as! String
                        newData.location = jsonElement["location"] as! String
                        newData.memo = jsonElement["memo"] as! String
                        newData.image = jsonElement["image"] as! String
                        self.fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData()  }
                }
            } catch { print("Error:") }
        }
        task.resume()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Favorite Cell", for: indexPath)

        // Configure the cell...
        let favorite = fetchedArray[indexPath.row]
        
        cell.textLabel?.text = favorite.name
        cell.detailTextLabel?.text = favorite.location

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toFavDetailView" {
            if let destVC = segue.destination as? FavDetailViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    let data = fetchedArray[selectedIndex]
                    destVC.selectedData = data
                    destVC.title = data.name
                }
            }
        }
        
    }

}
