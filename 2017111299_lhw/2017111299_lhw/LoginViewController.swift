//
//  LoginViewController.swift
//  LHW_2017111299
//
//  Created by SWUCOMPUTER on 23/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var textID: UITextField!
    @IBOutlet var textPW: UITextField!
    @IBOutlet var labelStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillLayoutSubviews() {
        textID.text=""
        textPW.text=""
        labelStatus.text=""
    }
    
    @IBAction func Login(_ sender: UIButton) {
        if textID.text == "" {
            labelStatus.text = "ID를 입력하세요"; return;
        }
        if textPW.text == "" {
            labelStatus.text = "비밀번호를 입력하세요"; return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/M10/login/loginUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        self.labelStatus.text = " "
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + textID.text! + "&password=" + textPW.text!
        
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any] else {
                    print("JSON Serialization Error!")
                    return
                }
                guard let success = jsonData["success"] as? String else {
                    print("Error: PHP failure(success)")
                    return
                }
                if success == "YES" {
                    if let name = jsonData["name"] as? String { DispatchQueue.main.async {
                        self.labelStatus.text = name + "님 안녕하세요?"
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.ID = self.textID.text
                        appDelegate.userName = name
                        appDelegate.PW = self.textPW.text
                        self.performSegue(withIdentifier: "toLoginSuccess", sender: self) }
                    }
                } else {
                    if let errMessage = jsonData["error"] as? String {
                        DispatchQueue.main.async { self.labelStatus.text = errMessage }
                    }
                    if let errMessage1 = jsonData["pw1"] as? String {
                        DispatchQueue.main.async { print(errMessage1) }
                    }
                    if let errMessage2 = jsonData["pw2"] as? String {
                        DispatchQueue.main.async { print(errMessage2) }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }

    

}
