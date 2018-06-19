//
//  CafeAddViewController.swift
//  Final_3
//
//  Created by SWUCOMPUTER on 2018. 5. 28..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class CafeAddViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var detailLoca: String!
    var cafeAddress: String!
    var cafeVC: UITableViewController? = nil
    let picker = UIImagePickerController()

    @IBOutlet var cafeName: UITextField!
    @IBOutlet var detailLocation: UILabel!
    @IBOutlet var cafeDAddress: UITextField!
    @IBOutlet var cafeLocation: UITextField!
    @IBOutlet var cafeMemo: UITextView!
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailLocation.text = detailLoca
        picker.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    @IBAction func addPicture(_ sender: Any) {
        
        let alert = UIAlertController(title: "Photo", message: "사진 가져오기", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) {(action) in self.openLibrary() }
        let camera = UIAlertAction(title: "카메라", style: .default) {(action) in self.openCamera() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        // 카메라가 없으므로 알림창을 띄움
        let alert = UIAlertController(title: "Error", message: "Device has no Camera!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imageView.image = image
            print(info)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        let name = cafeName.text!
        if let dAdd = cafeDAddress.text {
            cafeAddress = detailLoca + " " + dAdd
        }
        let location = cafeLocation.text!
        let memo = cafeMemo.text!
        
        if (name == "") {
            let alert = UIAlertController(title: "카페명을 입력하세요", message: "Save Failed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        guard let myImage = imageView.image else {
            let alert = UIAlertController(title: "이미지를 선택하세요", message: "Save Failed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        let myUrl = URL(string: "http://condi.swu.ac.kr/student/T11iphone/cafe/upload.php");
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        guard let imageData = UIImageJPEGRepresentation(myImage, 1) else { return }
        var body = Data()
        var dataString = "--\(boundary)\r\n"
        dataString += "Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"
        dataString += "Content-Type: application/octet-stream\r\n\r\n"
        
        if let data = dataString.data(using: .utf8) { body.append(data) }
        
        //imageData 위아래로 boundary 정보 추가
        body.append(imageData)
        
        dataString = "\r\n"
        dataString += "--\(boundary)--\r\n"
        
        if let data = dataString.data(using: .utf8) { body.append(data) }
        
        request.httpBody = body
        var imageFileName: String=""
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return;
            }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                //서버에 저장한 이미지 파일 이름
                imageFileName = utf8Data
                print(imageFileName)
                semaphore.signal()
            }
        }
        task.resume()
        //이미지 파일 이름을 서버롬부터 받은 후 해당 이름을 DB에 저장하기 위해 wait()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        let urlString: String = "http://condi.swu.ac.kr/student/T11iphone/cafe/insertCafe.php"
        guard let requestURL = URL(string: urlString) else { return }
        request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        guard let userID = appDelegate.ID else { return }
        var restString: String = "name=" + name
        restString += "&address=" + cafeAddress
        restString += "&location=" + location
        restString += "&memo=" + memo
        restString += "&image=" + imageFileName
        request.httpBody = restString.data(using: .utf8)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return }
            guard let receivedData = responseData else { return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
        }
        task2.resume()
        _ = self.navigationController?.popViewController(animated: true)
    }

}
