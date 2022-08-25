//
//  ViewController.swift
//  NoteTakingApp
//
//  Created by Vahit Yenihayat on 12.06.2022.
//

import UIKit
import CoreData

struct NoteModel {
    let id: UUID
    let textNote: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var notes = [NoteModel]()

    var selectedNote: NoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
       
        addNoteButton.isUserInteractionEnabled = true
        let addTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addButtonClicked))
        addNoteButton.addGestureRecognizer(addTapRecognizer)
        addNoteButton.alpha = 0.25
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
       }
    @objc func getData() {
        notes.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
            }
            for result in results as! [NSManagedObject] {
                if let id = result.value(forKey: "id") as? UUID,
                   let note = result.value(forKey: "note") as? String {
                    notes.append(.init(id: id, textNote: note))
                }
                self.tableView.reloadData()
            }
        }catch{
            print("error")
        }
    }
    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toNewNoteVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addNoteButton.isHidden = false
        return notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        addNoteButton.isHidden = true
        let cell = UITableViewCell()
        cell.textLabel?.text = notes[indexPath.row].textNote
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditVC"{
            let destinationVC = segue.destination as! EditVC
            destinationVC.note = selectedNote
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notes[indexPath.row]
        performSegue(withIdentifier: "toEditVC", sender: nil)
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            let idString = notes[indexPath.row].id.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let id = result.value(forKey: "id") as? UUID {

                            if id == notes[indexPath.row].id {
                                context.delete(result)
                                notes.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                do {
                                    try context.save()
                                } catch {
                                    print("error")
                                }
                                break
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
        }
    }
}

