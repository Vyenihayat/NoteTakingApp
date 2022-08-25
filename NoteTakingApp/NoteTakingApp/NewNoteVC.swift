//
//  NewNoteVC.swift
//  NoteTakingApp
//
//  Created by Vahit Yenihayat on 29.06.2022.
//

import UIKit
import CoreData

class NewNoteVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveButton: UINavigationItem!
    
    var chosenNote  = ""
    var chosenNoteId : UUID?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView.inputAccessoryView = toolbarView
        
      //let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))

        
        
        
        
        
        
        
        
        
        
        if chosenNote != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            let idString = chosenNoteId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let note = result.value(forKey: "note") as? String {
                            noteTextView.text = note
                        }
                    }
                    
                }
            }catch {
                print("error")
                }
            }else {
                noteTextView.text = ""
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
}

    
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
        
        //Attributes
        
        newNote.setValue(noteTextView.text, forKey: "note")
        newNote.setValue(UUID(), forKey: "id")
        do {
            try context.save()
            print("success")
        } catch{
            print("error")
        }
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
