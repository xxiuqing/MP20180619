//
//  FavDetailViewController.swift
//  Final_3
//
//  Created by SWUCOMPUTER on 2018. 6. 13..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class FavDetailViewController: UIViewController {

    @IBOutlet var favName: UITextField!
    @IBOutlet var favAddress: UITextView!
    @IBOutlet var favLocation: UITextField!
    @IBOutlet var favMemo: UITextView!
    @IBOutlet var favImage: UIImageView!
    
    var selectedData: FavoriteData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let favData = selectedData else { return }
        favName.text = favData.name
        favAddress.text = favData.address
        favLocation.text = favData.location
        favMemo.text = favData.memo
        var imageName = favData.image
        
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/T11iphone/favorite/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                favImage.image = UIImage(data: imageData)
            }
        }
        
    }

    
    @IBAction func buttonDelete() {
        let alert=UIAlertController(title:"관심 카페에서 삭제 하시겠습니까?", message: "",preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T11iphone/favorite/deleteFavorite.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            guard let favoriteNO = self.selectedData?.favNo else { return }
            let restString: String = "favoriteno=" + favoriteNO
            request.httpBody = restString.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
            }
            task.resume()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

}
