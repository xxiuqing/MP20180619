//
//  CafeDetailViewController.swift
//  Final_3
//
//  Created by SWUCOMPUTER on 2018. 5. 28..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class CafeDetailViewController: UIViewController {
    
    @IBOutlet var cafeName: UITextField!
    @IBOutlet var cafeAddress: UITextView!
    @IBOutlet var cafeLocation: UITextField!
    @IBOutlet var cafeMemo: UITextView!
    @IBOutlet var cafeImage: UIImageView!
    
    var selectedData: CafeData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        guard let cafeData = selectedData else { return }
        cafeName.text = cafeData.name
        cafeAddress.text = cafeData.address
        cafeLocation.text = cafeData.location
        cafeMemo.text = cafeData.memo
        var imageName = cafeData.image
        
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/T11iphone/cafe/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                cafeImage.image = UIImage(data: imageData)
            }
        }
    }
    
    @IBAction func bookmarkButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "자주가는 카페 추가", message: "관심 카페로 추가합니다", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil) //handler부분 수정하고 액션 추가
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)

        let urlString: String = "http://condi.swu.ac.kr/student/T11iphone/favorite/insertFavorite.php"
        
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        guard let cafeData = selectedData else { return }
        var restString: String = "name=" + cafeData.name
        restString += "&address=" + cafeData.address
        restString += "&location=" + cafeData.location
        restString += "&memo=" + cafeData.memo
        restString += "&image=" + cafeData.image
        request.httpBody = restString.data(using: .utf8)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return }
            guard let receivedData = responseData else { return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
        }
        task2.resume()
    }
}
