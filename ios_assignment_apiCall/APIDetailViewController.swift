//
//  APIDetailViewController.swift
//  ios_assignment_apiCall
//
//  Created by promact on 12/02/24.
//

import UIKit

class APIDetailViewController: UIViewController {

//    var selectedAPIData: APIEntity?
    var selectedAPIData: APIItem?
    var selectedAPIEntityData: APIEntity?
    
    @IBOutlet weak var apiNameLabel: UILabel!
    @IBOutlet weak var apiDescriptionLabel: UILabel!
    @IBOutlet weak var apiLinkLabel: UILabel!
    @IBOutlet weak var apiCategoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let selectedAPIData = selectedAPIData {
            
            apiNameLabel.text = selectedAPIData.api
            apiDescriptionLabel.text = selectedAPIData.description
            apiLinkLabel.text = selectedAPIData.link
            apiCategoryLabel.text = selectedAPIData.category
        }
        else if let selectedAPIEntityData = selectedAPIEntityData {
            apiNameLabel.text = selectedAPIEntityData.apiName
            apiDescriptionLabel.text = selectedAPIEntityData.apiDescription
            apiLinkLabel.text = selectedAPIEntityData.apiLink
            apiCategoryLabel.text = selectedAPIEntityData.apiCategory
        }
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
