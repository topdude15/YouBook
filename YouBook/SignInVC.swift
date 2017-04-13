//
//  ViewController.swift
//  YouBook
//
//  Created by Trevor Rose on 4/10/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController {

    @IBOutlet weak var usernameBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    
    
    //MARK: Misc code for hiding keyboard
    @IBAction func resignKeyboard(sender: AnyObject) {
        _ = sender.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "toFeed", sender: nil)
        }
    }

    @IBAction func continueTapped(_ sender: Any) {
        
        UserName.sharedInstance.email = self.usernameBox.text
        UserName.sharedInstance.password = self.passwordBox.text
        if let email = usernameBox.text, let password = passwordBox.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            let message = "Verify your e-mail and password are correct and try again"
                            let alertController = UIAlertController(
                                title: "Unable to log in",
                                message: message,
                                preferredStyle: .alert
                            )
                            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ -> Void in
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true)
                        } else {
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                DataService.ds.createFirebaseDBUser(uid: user.uid, userData: userData)
                                self.performSegue(withIdentifier: "toFeed", sender: nil)
                            }
                        }
                    })
                }
            })
        }
        
    }
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        performSegue(withIdentifier: "toFeed", sender: nil)
    }

}

