//
//  MemberViewController.swift
//  LHW_2017111299
//
//  Created by SWUCOMPUTER on 23/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelID: UILabel!
    @IBOutlet var labelStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelStatus.text=""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let name = appDelegate.userName {
            self.labelName.text = name
        }
        if let id = appDelegate.ID {
            self.labelID.text = id
        }
    }
    
    @IBAction func buttonLogout(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/M10/login/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return } }
            task.resume()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(withIdentifier: "LoginView")
            self.present(loginView, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    
    @IBAction func buttonCancel(_ sender: UIButton) {
        let alert = UIAlertController(title:"회원탈퇴 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/M10/login/cancle.php"
            guard let requestURL = URL(string: urlString) else {
                return
            }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let restString: String = "id=" + self.labelID.text!
            request.httpBody = restString.data(using: .utf8)
            self.executeRequest(request: request)

        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "LoginView")
        self.present(loginView, animated: true, completion: nil)

    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
