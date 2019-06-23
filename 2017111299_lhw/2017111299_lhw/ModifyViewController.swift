//
//  ModifyViewController.swift
//  LHW_2017111299
//
//  Created by SWUCOMPUTER on 23/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class ModifyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textName: UITextField!
    @IBOutlet var textPW: UITextField!
    @IBOutlet var labelStatus: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillLayoutSubviews() {
        super.viewDidLoad()
        
        labelStatus.text = ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if let name = appDelegate.userName {
            self.textName.text = name
        }
        if let pw = appDelegate.PW{
            self.textPW.text = pw
        }

    }
    
    @IBAction func buttonSave(_ sender: UIButton) {
        if textName.text == "" {
            labelStatus.text = "사용자 이름를 입력하세요"; return;
        }
        if textPW.text == "" {
            labelStatus.text = "비밀번호를 입력하세요"; return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/M10/login/update.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + appDelegate.ID! + "&password=" + textPW.text! + "&name=" + textName.text!
        request.httpBody = restString.data(using: .utf8)
        self.executeRequest(request: request)
    }
    
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else { print("Error: not receiving Data")
                return
            }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async {
                    // for Main Thread Checker
                    self.labelStatus.text = utf8Data
                    print(utf8Data) // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
            self.appDelegate.userName = self.textName.text
            self.appDelegate.PW = self.textPW.text
        }
        task.resume()
        self.dismiss(animated: true, completion: nil)
    }

}
