//
//  ViewController.swift
//  PhoneContact
//
//  Created by Zehra Nur Açık on 19.10.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var idArray = [UUID]()
    var surnameArray = [String]()
    
    var selectedName = ""
    var selectedUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // getData fonksiyonu çağrılır çünkü tableview da veriler gösterilecek.
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Bu kod, "dataEntry" adlı bir bildirimin yayınlandığını bekleyen ve bu bildirim geldiğinde getData adlı bir işlevi çağıran bir gözlemci ekler. Bu, uygulamanın farklı bileşenlerinin (sınıfların veya nesnelerin) birbirleriyle iletişim kurmasını sağlayan bir olay tabanlı bir yapı oluşturur.
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "dataEntry"), object: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row] + " " + surnameArray[indexPath.row]
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.selectedContactName = selectedName
            destinationVC.selectedContactUUID = selectedUUID
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selectedName = nameArray[indexPath.row]: Bu satır, nameArray adlı bir dizi içindeki indexPath.row ile belirtilen konumdaki veriyi alır ve selectedName adlı bir değişkene atar. Bu, kullanıcının tıkladığı hücreye ilişkin "name" verisini yakalar.
        selectedName = nameArray[indexPath.row]
        selectedUUID = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }

    @objc func getData(){
        
        nameArray.removeAll(keepingCapacity: false)
        surnameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Core Data veritabanından belirli bir Entity'de bulunan verileri sorgulamak için kullanılan bir NSFetchRequest nesnesi oluşturur. Bu kodun amacı, belirli bir Entity içindeki verilere erişim sağlamak ve bu verileri sorgulamak içindir.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            // Core Data veritabanından belirli bir sorgunun sonuçlarını alır ve bu sonuçları results adlı bir diziye atar.
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                // Sorgu sonuçlarını alır, onları NSManagedObject türüne dönüştürür ve ardından bu sonuçları bir döngü içinde tek tek işler.
                for result in results as! [NSManagedObject]{
                    
                    // Core Data daki her bir name attribute değerini name değişkenine atar ve nameArray dizisine yapıştırır. Bu sayede veri tabanındaki name kayıtlarına ulaşabiliriz.
                    if let name = result.value(forKey: "name") as? String{
                        nameArray.append(name)
                    }
                    
                    if let surname = result.value(forKey: "surname") as? String{
                        surnameArray.append(surname)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID{
                        idArray.append(id)
                    }
                }
            }
        } catch {
            print("Error")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
            
            let uuidString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if let id = result.value(forKey: "id") as? UUID{
                            if id == idArray[indexPath.row]{
                                context.delete(result)
                                nameArray.remove(at: indexPath.row)
                                surnameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                
                                do{
                                    try context.save()
                                } catch {
                                    print("Error")
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error")
            }
        }
    }
}


