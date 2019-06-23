//
//  JoinViewController.swift
//  LHW_2017111299
//
//  Created by SWUCOMPUTER on 23/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textID: UITextField!
    @IBOutlet var textPW: UITextField!
    @IBOutlet var textPW2: UITextField!
    @IBOutlet var textName: UITextField!
    @IBOutlet var labelStatus: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillLayoutSubviews() {
        labelStatus.text=""
    }

    @IBAction func buttonBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Join(_ sender: UIButton) {
        // 필요한 세 가지 자료가 모두 입력 되었는지 확인
        if textID.text == "" {
            labelStatus.text = "ID를 입력하세요"; return; }
        if textPW.text == "" {
            labelStatus.text = "PW를 입력하세요"; return; }
        if textPW2.text == "" {
            labelStatus.text = "PW*를 입력하세요"; return; }
        if textName.text == "" {
            labelStatus.text = "사용자 이름을 입력하세요"; return;}
        if textPW.text != textPW2.text {
            labelStatus.text = "Pw와 Pw*가 일치하지 않습니다."; return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/M10/login/insertUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + textID.text! + "&password=" + textPW.text! + "&name=" + textName.text!
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
        }
        task.resume()
    }

    
}
