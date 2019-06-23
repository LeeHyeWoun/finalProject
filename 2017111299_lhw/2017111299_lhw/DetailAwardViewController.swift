//
//  DetailAwardViewController.swift
//  2017111299_lhw
//
//  Created by SWUCOMPUTER on 23/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailAwardViewController: UIViewController {

    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelAchivement: UILabel!
    @IBOutlet var textMemo: UITextView!
    
    var detailAwardData: NSManagedObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let award = detailAwardData{
            self.title = award.value(forKey: "title") as? String
            
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let core:Date? = award.value(forKey: "date") as? Date
            if let unwrapDate = core {
                labelDate.text = formatter.string(from: unwrapDate as Date) }
            
            labelAchivement.text = award.value(forKey: "achievement") as? String

            textMemo.text = award.value(forKey: "memo") as? String
            
        }

    }
    
}
