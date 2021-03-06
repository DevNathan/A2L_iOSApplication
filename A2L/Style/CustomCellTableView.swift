//
//  CustomCellTableView.swift
//  A2L
//
//  Created by Nathan on 09/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

//Custom qui permet d'ajouter un label au cellule des tableView



class CustomTableViewCell: UITableViewCell {
    
    let statut = UILabel()
    let info = UIButton()
    let iconCell = UIImageView()
    let imageAtEnd = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var isDarkMode = "false"
        do {
            isDarkMode = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(isDarkModeActivated), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        
        if isDarkMode == "true" {
            statut.textColor = .lightGray
        } else {
            statut.textColor = .gray
        }
        statut.textAlignment = .right
        statut.frame = CGRect(x: 170, y: 9, width: 200, height: 30)
        contentView.addSubview(statut)
        
        info.tintColor = .blue
        info.frame = CGRect(x: 340, y: 6, width: 30, height: 30)
        contentView.addSubview(info)
        
        imageAtEnd.frame.size.width = 30
        imageAtEnd.frame.size.height = 30
        imageAtEnd.center.y = self.contentView.center.y 
        contentView.addSubview(imageAtEnd)
        
        iconCell.frame = CGRect(x: 5, y: 6, width : 30, height: 30)
        contentView.addSubview(iconCell)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
