//
//  OptionsVC.swift
//  Grocery
//
//  Created by Melody on 12/10/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import UIKit

class OptionsVC: UIViewController {
   
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    var recipes = [Recipes]()
    
    var recipeName: String!
    var imageURL: String!
    var ingredients = [String]()
    var recipeURL: String!
//    var userRecipes = [Recipes]()
    
    var notes: Notes!
    
//    func passData(data: String) {
//        print("got data")
//    }
    
    @IBAction func addNotes(_ sender: Any) {
        var inputOption = ""
        var inputNote = ""
        
        let alertController = UIAlertController(title: "Add Some Notes", message: "What other ingredient did you add?", preferredStyle: .alert)
       alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Other ingredients"
            inputOption = textField.text!
        }
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Add some notes"
            inputNote = textField.text!
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.notes = Notes(ingredientOptions: inputOption, note: inputNote)
        }
        
        
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func ingredientsPressed(_ sender: Any) {
//        showCollectionView()
//        passDataToCollectionView()
        passDataToTableView()
        scrollView.isHidden = false
        
    }
    
    @IBAction func stepsPressed(_ sender: Any) {
        
        let webVC = storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! WebViewVC
        webVC.urlString = recipeURL
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    @IBAction func notesPressed(_ sender: Any) {
         let param = ["email": "\(keychain.get("email")!)", "recipeName": recipeName!]
        Networking.shared.fetch(route: .retrieveRecipe, data: nil, params: param) { data in
            let note = try? JSONDecoder().decode(UserRecipe.self, from: data)
            let recipeList = note?.recipes
            self.recipes = recipeList!
            
//            print(note)
        }
        scrollView.isHidden = true
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        showCollectionView()
        showIngredientTableView()
    
        recipeNameLabel.text = recipeName
        
        DispatchQueue.main.async {
            self.recipeImageView.getImageFromURL(url: self.imageURL)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passDataToTableView()
        passDataToCollectionView()
        
//        let param = ["email": "\(keychain.get("email")!)", "recipeName": recipeName!]
//
//        if notes != nil {
//             Networking.shared.fetch(route: .saveNote, data: notes, params: param) { _ in}
//        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension OptionsVC {
    
    func showCollectionView() {
        let collectionVC = storyboard?.instantiateViewController(withIdentifier: "collectionVC")
        addChildViewController(collectionVC!)
        scrollView.addSubview((collectionVC?.view)!)
    
    }
    
    func showIngredientTableView() {
        let optionTableVC = storyboard?.instantiateViewController(withIdentifier: "optionTableVC")
        addChildViewController(optionTableVC!)
        tableView.addSubview((optionTableVC?.view)!)
    }
    
    func passDataToCollectionView() {
        if let collectionVC = self.childViewControllers.first as? OptionCollectionVC {
            collectionVC.recipes = recipes
        }
    }
    
    func passDataToTableView() {
        if let optionTableVC = self.childViewControllers[1] as? OptionTableVC {
            optionTableVC.ingredients = ingredients
        }
    }
    
    
    
    
    
}
