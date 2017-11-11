//
//  MainTableViewController.swift
//  reverso-dictionnaire
//
//  Created by eleves on 2017-11-08.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var laguageView: UIView!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var pickerLanguage: UIPickerView!
    @IBOutlet weak var buttonExpansion: UIButton!
    
    //UserDefaults
    let userDefaults = UserDefaults.standard
    
    //Selected language
    var selectedTranslation: Int!
    
    // Language Expansion
    var isExpanded = false
    
    // Arrow's images
    var imageArrowRight = UIImage(named: "arrow-right")
    var imageArrowDown = UIImage(named: "arrow-down")
    
    private let languages = [(1, "French -> English"), (2, "English -> French"),
                             (3, "French -> Portuguese"), (4, "Portuguese -> French"),
                             (5, "English -> Portuguese"), (6, "Portuguese -> English")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Large titles and search bar
        setUpNavBar()
        
        //removes empty cells
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //load SelectedTranslation
        setTranslationLanguage()
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setTranslationLanguage() {
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
        }
    }
    
    func colapseExpansion() {
        imageArrow.image = imageArrowRight
        // Expand animation
        let viewWidth = view.frame.width
        let viewHeight = CGFloat(55)
        UIView.animate(withDuration: 0.3, animations: {
            self.laguageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        }, completion: { (finished: Bool) in
            self.pickerLanguage.isHidden = true
        })
        // Expand animation
        isExpanded = false
    }
    
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        colapseExpansion()
        
        let editViewController = segue.destination as! EditWordViewController
        if segue.identifier == "addSegue" {
            editViewController.isNewWord = true
        } else {
            editViewController.isNewWord = false
        }
        
    }
    
}

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


// Extension Picker
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
    }
    
}
















