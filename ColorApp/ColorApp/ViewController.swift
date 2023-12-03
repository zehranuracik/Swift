//
//  ViewController.swift
//  ColorApp
//
//  Created by Zehra Nur Açık on 19.11.2023.
//

import UIKit

class ViewController: UIViewController {

    var colorArray : [UIColor] = []
    
    // Birden çok cell ve segue identifier vars enum kullanışlı olur. Yazım hatasından kaçınmak için kullanılır.
    
    enum Cells{
        static let colorCell = "ColorCell"
    }
    
    enum Segues{
        static let toDetail = "ToColorDetailsVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendRandomColor()
    }
    
    func appendRandomColor(){
        for _ in 1...50{
            colorArray.append(.random())
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ColorDetailsVC
        destVC.color = sender as? UIColor
    }
    
}
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.colorCell) else{
            return UITableViewCell()
        }
        cell.backgroundColor = colorArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color = colorArray[indexPath.row]
        performSegue(withIdentifier: Segues.toDetail , sender: color)
    }
    
}

