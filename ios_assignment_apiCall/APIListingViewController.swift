//
//  APIListingViewController.swift
//  ios_assignment_apiCall
//
//  Created by promact on 08/02/24.
//

import UIKit
import Network
import CoreData

class APIListingViewController: UIViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var apiList: [String] = ["nice", "api", "listing"]
    
    let apiitem1 = APIItem(api: "api1", description: "nice api", link: "api@api.com", category: "listing")
    
    
    var apiList: [APIItem] = [APIItem]()
    
    // list of the data to be fetched
    var apiEntityList: [APIEntity] = [APIEntity]()

    @IBOutlet weak var myAPITable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print("IOS version \(systemVersion)")
        
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myAPITable.dataSource = self
        APICall(URL: "https://api.publicapis.org/entries") { APIsObject in
            
//            DispatchQueue.main.async {
//                self.internetConnectivity()
//            }
//            self.internetConnectivity()
            NetworkConnectivity.internetConnectivity { isConnected in
                
                if isConnected {
                    self.deleteAPIEntityData(entity: "APIEntity")
                    let arrayOfAPIItems = Array<APIItem>(APIsObject.entries[..<50])
                    let _ = arrayOfAPIItems.map { apiItem in
                        let entity = NSEntityDescription.insertNewObject(forEntityName: "APIEntity", into: self.context) as! APIEntity
                            entity.apiName = apiItem.api
                            entity.apiDescription = apiItem.description
                            entity.apiLink = apiItem.link
                            entity.apiCategory = apiItem.category
                        
                        do {
                            try self.context.save()
                        } catch {
                            print("Error saving data to Core Data: \(error)")
                        }
                    }

                    self.apiList = arrayOfAPIItems
                    DispatchQueue.main.async {
                        self.myAPITable.reloadData()
                    }
                }
                else {
//                    print(self.apiList)
                    let fetchAPIsList = NSFetchRequest<APIEntity>(entityName: "APIEntity")

                    do {
                        self.apiEntityList = try self.context.fetch(fetchAPIsList)

//                        print(self.apiEntityList)
                        DispatchQueue.main.async {
                            self.myAPITable.reloadData()
                        }

                    } catch {
                        print(error)
                    }
                }
            }
            
            
        }
    }
    
    func deleteAPIEntityData(entity: String)
    {
        let managedContext = self.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let previousData = try managedContext.fetch(fetchRequest)
            for managedObject in previousData
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    // fetch the data using API call, and decode into Array<APIItem>
    func APICall(URL url: String, completion: @escaping (APIsObject) -> Void) {
        
        
        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            let decoder = JSONDecoder()
            
            if let data = data {
                // print(data)
                do {
                    let apisObject = try decoder.decode(APIsObject.self, from: data)
                    completion(apisObject)
                    
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
}



extension APIListingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !apiList.isEmpty {
            return apiList.count
        }
        else {
            return apiEntityList.count
        }
        
//        return apiEntityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = myAPITable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//         for latest development
        if #available(iOS 14, *) {
            let content = cell?.defaultContentConfiguration()
            if var content = content {
                if !apiList.isEmpty {
                    content.text = apiList[indexPath.row].api
                    content.secondaryText = apiList[indexPath.row].category
                    
                } else {
                    content.text = apiEntityList[indexPath.row].apiName
                    content.secondaryText = apiEntityList[indexPath.row].apiCategory
                }
                
                content.image = UIImage(systemName: "list.bullet.rectangle")
                cell?.contentConfiguration = content
                
            }

        }
        // for older versions of iPhone
        else {
            // print(indexPath.row as Int)
            
            if !apiList.isEmpty {
                cell?.textLabel?.text = apiList[indexPath.row].api
                cell?.detailTextLabel?.text = apiList[indexPath.row].category
            } else {
                cell?.textLabel?.text = apiEntityList[indexPath.row].apiName
                cell?.detailTextLabel?.text = apiEntityList[indexPath.row].apiCategory
            }
            
            cell?.imageView?.image = UIImage(systemName: "list.bullet.rectangle")
        }
//        print("Line 100 \(apiList[indexPath.row])")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "APIListingToAPIDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "APIListingToAPIDetail" {
            let indexPath = self.myAPITable.indexPathForSelectedRow!
            let APIDetailView = segue.destination as! APIDetailViewController
            
            if !apiList.isEmpty {
                APIDetailView.selectedAPIData = apiList[indexPath.row]
            } else {
                APIDetailView.selectedAPIEntityData = apiEntityList[indexPath.row]
            }
            self.myAPITable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
}
