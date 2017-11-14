//
//  EditWordViewController.swift
//  reverso-dictionnaire
//
//  Created by eleves on 2017-11-08.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class EditWordViewController: UITableViewController {
    
    @IBOutlet weak var textFieldWord: UITextField!
    @IBOutlet weak var textFieldTranslation: UITextField!
    
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var laguageView: UIView!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var pickerLanguage: UIPickerView!
    @IBOutlet weak var languageCell: UITableViewCell!
    
    //UserDefaults
    private let userDefaults = UserDefaults.standard
    
    //Selected language
    private var selectedTranslation: Int!
    
    // Language Expansion
    private var isExpanded = false
    
    // Arrow's images
    var imageArrowRight = UIImage(named: "arrow-right")
    var imageArrowDown = UIImage(named: "arrow-down")
    
    private let languages = [(1, "French  ->  English"), (2, "English  ->  French"),
                     (3, "French  ->  Portuguese"), (4, "Portuguese  ->  French"),
                     (5, "English  ->  Portuguese"), (6, "Portuguese  ->  English")]
    
    var isNewWord = false
    
    var editingWord: String?
    var editingTranslation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        languageCell.frame.origin.y = 0
        
        //load SelectedTranslation
        setTranslationLanguage()
        
        //Set title
        if isNewWord {
            self.title = "Add Word"
        } else {
            self.title = "Edit Word"
            tableView.allowsSelection = false
            imageArrow.isHidden = true
            textFieldWord.isEnabled = false
            textFieldWord.text = editingWord
            textFieldTranslation.text = editingTranslation
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isNewWord {
            textFieldWord.becomeFirstResponder()
        } else {
            textFieldTranslation.becomeFirstResponder()
        }
    }
    
    func setTranslationLanguage() {
        laguageView.frame.size.height = CGFloat(55)
        
        laguageView.setBottomBorder()
        
        if let savedTranslation = userDefaults.object(forKey:"selectedTranslation") as? Int {
            self.selectedTranslation = savedTranslation
        } else {
            selectedTranslation = 1;
        }
        pickerLanguage.isHidden = true
        pickerLanguage.selectRow((selectedTranslation - 1), inComponent: 0, animated: true)
        labelLanguage.text = languages[(selectedTranslation - 1)].1
    }
    
    func colapseExpansion() {
        imageArrow.image = imageArrowRight
        self.pickerLanguage.isHidden = true
        // Expand animation
        let viewWidth = view.frame.width
        let viewHeight = CGFloat(55)
        UIView.animate(withDuration: 0.3, animations: {
            self.laguageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        }, completion: { (finished: Bool) in
            
        })
        // Expand animation
        isExpanded = false
        textFieldWord.becomeFirstResponder()
    }

    
    @IBAction func textFieldTouchDown(_ sender: UITextField) {
        if isExpanded {
            isExpanded = false
            if !sender.isFirstResponder {
                sender.perform(#selector(becomeFirstResponder), with: nil, afterDelay: 0.1)
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if !textFieldWord.text!.isEmpty && !textFieldTranslation.text!.isEmpty {
            let word = textFieldWord.text!.lowercased()
            let translation = textFieldTranslation.text!.lowercased()
            
            let listNumber = findListNumber()
            if var dataStructure = userDefaults.object(forKey:"list\(listNumber)") as? [String: String] {
                if dataStructure.contains(where: { (key, value) in
                    if self.selectedTranslation % 2 != 0{
                        return key == word
                    } else {
                        return value == word
                    }
                }) {
                    if self.selectedTranslation % 2 != 0{
                        dataStructure[word] = translation
                    } else {
                        dataStructure[translation] = word
                    }
                } else {
                    dataStructure[word] = translation
                }
                userDefaults.set(dataStructure, forKey: "list\(listNumber)")
            } else {
                if self.selectedTranslation % 2 != 0{
                    userDefaults.set([word : translation], forKey: "list\(listNumber)")
                } else {
                    userDefaults.set([translation : word], forKey: "list\(listNumber)")
                }
            }
            
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Attention",
                                        message: "Please, enter the word and the translation correctelly",
                                        preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func findListNumber() -> Int {
        if selectedTranslation <= 2 {
            return 2
        } else if selectedTranslation <= 4 {
            return 4
        } else {
            return 6
        }
    }
    
    func manageExpansion() {
        if isExpanded {
            colapseExpansion()
        } else {
            // Expand animation
            let viewWidth = view.frame.width
            let viewHeight = CGFloat(200)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.laguageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
            }, completion: { (finished: Bool) in
                self.pickerLanguage.isHidden = false
            })
            // Expand animation
            
            imageArrow.image = imageArrowDown
            isExpanded = true
            textFieldWord.resignFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }

}

extension EditWordViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        } else if section == 1 {
            return 30
        }
        return 20
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            manageExpansion()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if isExpanded {
                return 200
            } else {
                return 50
            }
        }
        return 50
    }
}

// Extension Picker
extension EditWordViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row].1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTranslation = languages[row].0
        userDefaults.set(selectedTranslation, forKey: "selectedTranslation")
        labelLanguage.text = languages[row].1
    }
    
}



