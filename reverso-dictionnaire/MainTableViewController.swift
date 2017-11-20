//
//  MainTableViewController.swift
//  reverso-dictionnaire
//
//  Created by Henrique Nascimento on 2017-11-08.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

// Main ViewController of the application
class MainTableViewController: UITableViewController {
    
    //MARK: Outlets
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var laguageView: UIView!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var pickerLanguage: UIPickerView!
    @IBOutlet weak var buttonExpansion: UIButton!
    //MARK: Outlets
    
    //UserDefaults
    let userDefaults = UserDefaults.standard
    
    //MARK: Search bar
    var searchBar: UISearchBar!
    var searchController: UISearchController!
    private var isSearching = false
    private var filteredWords = [(key:String, value:String)]()
    //MARK: Search bar
    
    //MARK: Language Selection
    var selectedTranslation: Int!
    var isExpanded = false
    private let languages = [(1, NSLocalizedString("French  ->  English", comment: "")),
                             (2, NSLocalizedString("English  ->  French", comment: "")),
                             (3, NSLocalizedString("French  ->  Portuguese", comment: "")),
                             (4, NSLocalizedString("Portuguese  ->  French", comment: "")),
                             (5, NSLocalizedString("English  ->  Portuguese", comment: "")),
                             (6, NSLocalizedString("Portuguese  ->  English", comment: ""))]
    
    // Tuples to display without filter
    private var words = [(key:String, value:String)]()
    //MARK: Language Selection
    
    //MARK: TableView's properties
    // Arrow's images
    var imageArrowRight = UIImage(named: "arrow-right")
    var imageArrowDown = UIImage(named: "arrow-down")
    var selectedRow: Int?
    //MARK: TableView's properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        // Removes empty cells
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //load SelectedTranslation
        setUpTranslationSelector()
        loadWords()
        tableView.reloadData()
    }
    /*
     Load dataStructure from user defaults:
        if dataStructure % 2
            use key + value
        else
            use value + key
    */
    func loadWords() {
        let listNumber = findListNumber()
        if let dataStructure = userDefaults.object(forKey:"list\(listNumber)") as? [String: String] {
            if selectedTranslation % 2 != 0{
                words = dataStructure.sorted(by: {t1, t2 in
                    return t1.key < t2.key
                })
            } else {
                words = dataStructure.sorted(by: {t1, t2 in
                    return t1.value < t2.value
                })
            }
        } else {
            words.removeAll()
        }
    }
    
    // Get the number of the selected list
    private func findListNumber() -> Int {
        if selectedTranslation <= 2 {
            return 2
        } else if selectedTranslation <= 4 {
            return 4
        } else {
            return 6
        }
    }
    
    func colapseExpansion() {
        imageArrow.image = imageArrowRight
        // Expand animation
        let viewWidth = view.frame.width
        let viewHeight = CGFloat(55)
        UIView.animate(withDuration: 0.3, animations: {
            self.laguageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
            self.tableView.reloadData()
        }, completion: { (finished: Bool) in
            self.pickerLanguage.isHidden = true
        })
        // Expand animation
        isExpanded = false
    }
    
    // MARK: Actions
    @IBAction func manageExpansion(_ sender: UIButton) {
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
            self.tableView.reloadData()
        }
    }
    // MARK: Actions
    
    
    
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
                
        let editViewController = segue.destination as! EditWordViewController
        if segue.identifier == "addSegue" {
            editViewController.isNewWord = true
        } else {
            navigationController?.dismiss(animated: true, completion: nil)
            var wordsToShow: [(key:String, value:String)]
            if isSearching {
                wordsToShow = filteredWords
            } else {
                wordsToShow = words
            }
            editViewController.isNewWord = false
            if selectedTranslation % 2 != 0 {
                editViewController.editingWord = wordsToShow[selectedRow!].key
                editViewController.editingTranslation = wordsToShow[selectedRow!].value
            } else {
                editViewController.editingWord = wordsToShow[selectedRow!].value
                editViewController.editingTranslation = wordsToShow[selectedRow!].key
            }
        }
        colapseExpansion()
    }
    // MARK: Prepare for segue
    
}

//MARK: MainTableViewController's Style
extension MainTableViewController {
    // Configs navigation bar
    func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar = searchController.searchBar
        
        // Customized Search Bar
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.white
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            textfield.tintColor = UIColor(red: 44/255, green: 128/255, blue: 180/255, alpha: 1.0)
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        // Customized Search Bar
        
        searchBar.delegate = self
    }
    
    // Configs language selector
    func setUpTranslationSelector() {
        buttonExpansion.setBackgroundColor(color: UIColor.lightGray, forState: UIControlState.highlighted)
        buttonExpansion.setBackgroundColor(color: UIColor.lightGray, forState: UIControlState.application)
        
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
}



//MARK: Extension Picker
extension MainTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        loadWords()
        tableView.reloadData()
    }
    
}

//MARK: Extension TableViewController
extension MainTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isExpanded {
            colapseExpansion()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredWords.count
        } else {
            return words.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordsCell", for: indexPath) as! TranslationTableViewCell
        
        var wordsToShow: [(key:String, value:String)]
        if isSearching {
            wordsToShow = filteredWords
        } else {
            wordsToShow = words
        }
        
        if selectedTranslation % 2 != 0{
            cell.labelWord.text = wordsToShow[indexPath.item].key
            cell.labelTranslation.text = wordsToShow[indexPath.item].value
        } else {
            cell.labelWord.text = wordsToShow[indexPath.item].value
            cell.labelTranslation.text = wordsToShow[indexPath.item].key
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row        
        performSegue(withIdentifier: "editSegue", sender: tableView)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedTuple: (key:String, value:String)
            if isSearching {
                let removedWord = filteredWords[indexPath.item]
                filteredWords.remove(at: indexPath.item)
                let index = words.index(where: {t in
                    return t.key == removedWord.key && t.value == removedWord.value
                })
                removedTuple = words.remove(at: index!)
            } else {
                removedTuple = words.remove(at: indexPath.item)
            }
            
            let listNumber = findListNumber()
            var dataStructure = userDefaults.object(forKey:"list\(listNumber)") as? [String: String]
            dataStructure![removedTuple.key] = nil
            userDefaults.set(dataStructure, forKey: "list\(listNumber)")
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

//MARK: Extension SearchBar
extension MainTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            tableView.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredWords = words.filter({ t in
                let typedTextLowercased = searchBar.text!.lowercased()
                let key = t.key.folding(options: .diacriticInsensitive, locale: .current)
                let value = t.value.folding(options: .diacriticInsensitive, locale: .current)
                let containsInKey = key.contains(typedTextLowercased)
                let containsInValue = value.contains(typedTextLowercased)
                return (containsInKey || containsInValue)
            })
            tableView.reloadData()
        }
    }
}


//MARK: Custom default components
extension UIView {
    func setBottomBorder() {
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.8)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 0.0
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}