//
//  DetailsViewController.swift
//  PhoneContact
//
//  Created by Zehra Nur Açık on 19.10.2023.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var selectedContactName = ""
    var selectedContactUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ekrana dokunduğumzda klavyeyi kapatmak için gesture recognizer ekledik.
        let keyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(keyboardGestureRecognizer)
        
        // core data da seçilen ürün bilgilerini gösterir
        if selectedContactName != "" {
            
            saveButton.isHidden = true
            
            nameTextField.isUserInteractionEnabled = false
            surnameTextField.isUserInteractionEnabled = false
            phoneTextField.isUserInteractionEnabled = false
            
            if let uuidString = selectedContactUUID?.uuidString{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
                
                //Bu kod, Core Data'da veri sorgularken filtreleme yapmanızı sağlar. Özellikle belirli bir "id" değerine sahip nesneyi almak istediğinizde veya belirli bir koşula uyan nesneleri seçmek istediğinizde kullanışlıdır. Örneğin, uuidString değişkeni belirli bir UUID'yi temsil ediyorsa, bu kod sorgunun sadece bu UUID'ye sahip nesneleri getirmesini sağlar.
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count > 0 {
                        
                        for result in results as! [NSManagedObject] {
                            
                            if let name = result.value(forKey: "name") as? String{
                                nameTextField.text = name
                            }
                            
                            if let surname = result.value(forKey: "surname") as? String{
                                surnameTextField.text = surname
                            }
                            
                            if let phone = result.value(forKey: "phone") as? String{
                                phoneTextField.text = phone
                            }
                        }
                    }
                    
                } catch{
                    print("Error")
                }
            }
            
        }
        
        else {
            saveButton.isHidden = false
            saveButton.isEnabled = false
            nameTextField.text = ""
            surnameTextField.text = ""
            phoneTextField.text = ""
        }
        phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func closeKeyboard(){
        // endEditing : Bu yöntem, eğer klavye açıksa, klavyeyi kapatır.

        view.endEditing(true)
    }

    @objc func phoneTextFieldDidChange(_ textField: UITextField) {
        // phoneTextField metni değiştiğinde bu fonksiyon çağrılır.

        // Eğer phoneTextField boş değilse, saveButton'ı etkinleştir.
        if let text = textField.text, !text.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
  
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        //  AppDelegate sınıfına erişim sağlar.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //Core Data ile çalışırken kullanılan bir NSManagedObjectContext örneği oluşturur. Core Data'daki verileri yönetmek ve değişiklikleri uygulamak için kullanılan temel bir bileşendir.
        let context = appDelegate.persistentContainer.viewContext
        
        // contact: Bu değişken, oluşturulan yeni veri nesnesinin bir referansını tutar. Bu nesne, "Contact" adlı bir Entity'e (veri tablosu veya sınıf) ait veriyi temsil eder.
        // NSEntityDescription: Core Data'nın bir parçası olan ve Entity'leri (veri yapıları) tanımlamak için kullanılan sınıftır.
        // insertNewObject(forEntityName:into:): Bu metot, yeni bir NSManagedObject (veri nesnesi) oluşturur ve bu nesneyi belirtilen Entity adına ait NSManagedObjectContext içine ekler. forEntityName parametresi, hangi Entity'ye ait bir nesne oluşturulacağını belirtir. into parametresi ise nesnenin hangi bağlam (context) içine ekleneceğini belirtir.
        // Bu nesne daha sonra bu context içindeki diğer işlemlerle birlikte kullanılabilir.
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context)
        
        // Kullanıcının bir metin girdisi (nameTextField.text) sağladığı bir kişi adını "name" özelliğine atamak için kullanılır.
        // forkey: bu alana oluşturulan entity deki attribute ismi girilir.
        if let nameText = nameTextField.text, !nameText.isEmpty{
            contact.setValue(nameTextField.text!, forKey: "name")
        } else {
            let alertController = UIAlertController(title: "Error", message: "Enter The Contact Name!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            return
        }
            
        
        contact.setValue(surnameTextField.text!, forKey: "surname")
        
        // Eğer phoneTextField'daki metni başarıyla bir tamsayıya (Int) dönüştürebiliyorsanız, bu değeri kaydeder.
        if let phoneText = phoneTextField.text, let phone = Int(phoneText) {
            contact.setValue(phoneTextField.text!, forKey: "phone")
        } else {
        // Eğer phoneTextField'daki metni Int'e dönüştüremiyorsanız, hata mesajı yazdırın ve işlemi durdurun.
            let alertController = UIAlertController(title: "Error", message: "Invalid Phone Field!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            self.phoneTextField.text = ""
            return
        }
           
        
        contact.setValue(UUID(), forKey: "id")
        
        // Core Data'da yapılan değişiklikleri (örneğin, yeni bir nesnenin eklendiği veya var olan bir nesnenin güncellendiği) veritabanına kaydetmek için kullanılır. Bu kod, NSManagedObjectContext üzerinde yapılan değişiklikleri kalıcı olarak saklamak için gereklidir. try context.save() ve ilgili catch bloğu, Core Data ile yapılan veritabanı işlemlerini güvenli bir şekilde gerçekleştirmek ve hataları ele almak için kullanılır. Eğer kaydetme işlemi başarılıysa, "saved" mesajı görüntülenir; eğer hata oluşursa, "Error" mesajı görüntülenir ve hatanın türüne bağlı olarak ek hata işlemleri gerçekleştirilebilir.
        do{
            try context.save()
            print("saved")
        } catch{
            print("Error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataEntry"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
