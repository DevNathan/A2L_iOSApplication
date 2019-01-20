//
//  ConnexionAdherent.swift
//  A2L
//
//  Created by Nathan on 17/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class ConnexionAdherent: UIViewController {
    
    @IBOutlet weak var titreLabel: UILabel!
    @IBOutlet weak var prenomField: UITextField!
    @IBOutlet weak var nomField: UITextField!
    @IBOutlet weak var jourField: UITextField!
    @IBOutlet weak var moisField: UITextField!
    @IBOutlet weak var anneeField: UITextField!
    @IBOutlet weak var slashLabel: UILabel!
    @IBOutlet weak var otherSlahLabel: UILabel!
    @IBOutlet weak var validerButton: UIButton!
    @IBOutlet weak var connexionAdminButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBackground()
        titreLabel.superview?.addSubview(titreLabel)
        prenomField.superview?.addSubview(prenomField)
        nomField.superview?.addSubview(nomField)
        jourField.superview?.addSubview(jourField)
        moisField.superview?.addSubview(moisField)
        anneeField.superview?.addSubview(anneeField)
        slashLabel.superview?.addSubview(slashLabel)
        validerButton.superview?.addSubview(validerButton)
        connexionAdminButton.superview?.addSubview(connexionAdminButton)
        otherSlahLabel.superview?.addSubview(otherSlahLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setViewBackground(){
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradient.colors = [UIColor.blue.cgColor, UIColor.black.cgColor]// rgb(173, 204, 255), rgb(113, 166, 252)
        self.view.layer.addSublayer(gradient)
        
        
    }
}


