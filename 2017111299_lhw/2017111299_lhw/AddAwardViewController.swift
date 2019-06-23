//
//  AddAwardViewController.swift
//  2017111299_lhw
//
//  Created by SWUCOMPUTER on 23/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class AddAwardViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var textTitle: UITextField!
    @IBOutlet var textAchievement: UITextField!
    @IBOutlet var textMemo: UITextView!
    @IBOutlet var labelStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelStatus.text = ""
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder()
        return true
    }

    
    @IBAction func buttonSave(_ sender: UIBarButtonItem) {
        if textTitle.text == "" {
            labelStatus.text = "Title을 입력하세요"; return;
        }
        if textMemo.text == "" {
            labelStatus.text = "Memo을 입력하세요"; return;
        }
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Awards", in: context)
        
        // award record를 새로 생성함
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(textTitle.text, forKey: "title")
        object.setValue(textAchievement.text, forKey: "achievement")
        object.setValue(textMemo.text, forKey: "memo")
        object.setValue(Date(), forKey: "date")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        // 현재의 View를 없애고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
    }

}
