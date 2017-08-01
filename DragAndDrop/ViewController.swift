//
//  ViewController.swift
//  DragAndDrop
//
//  Created by sycf_ios on 2017/8/1.
//  Copyright © 2017年 shibiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textView: UITextView!
    
    var tableViewData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textDragDelegate = self
        tableView.dropDelegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: UITextDragDelegate, UITableViewDropDelegate {
    func textDraggableView(_ textDraggableView: UIView & UITextDraggable, dragPreviewForLiftingItem item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "heart"))
        imageView.backgroundColor = .clear
        
        let dragView = textDraggableView
        let dragPoint = session.location(in: dragView)
        let target = UIDragPreviewTarget(container: dragView, center: dragPoint)
        
        return UITargetedDragPreview(view: imageView, parameters: UIDragPreviewParameters(), target: target)
    }
    
    func textDraggableView(_ textDraggableView: UIView & UITextDraggable, itemsForDrag dragRequest: UITextDragRequest) -> [UIDragItem] {
        
        if let string = textView.text(in: dragRequest.dragRange) {
            print(string)
            let itemProvider = NSItemProvider(object: string as! NSString)
            return [UIDragItem(itemProvider: itemProvider)]
        }else {
            return []
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let desIndexPath: IndexPath
        
        if  let indexPath = coordinator.destinationIndexPath {
            desIndexPath = indexPath
        }else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            desIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let stringsArray = items as? [String] else {return }
            
            self.tableViewData.insert(stringsArray.first!, at: desIndexPath.row)
            tableView.insertRows(at: [desIndexPath], with: .automatic)
        }
    }
    
    
    
}
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableViewData[indexPath.row]
        return cell
    }
}
