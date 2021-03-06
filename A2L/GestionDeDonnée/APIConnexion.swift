//
//  LocationModel.swift
//  A2L
//
//  Created by Nathan on 16/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class APIConnexion {
    
    var allInfo: [[String:String]] = [[:]]// Voila le tableau qui résumera toutes les données de tous les adhérents
    //Va chercher et convertie les données codées en JSON.
    public func exctractAllData(nom: String, mdpHashed: String) {
        //l'URL de l'API avec les données voulues.
        
        //ATTENTION : Les données transmises par l'URL doivent être sûr. Il doit bien s'agir d'un nom suivit d'un prénom, et d'un mot de passe hashé
        //Les caractères spéciaux devront être remplacés
        //L'API se charge juste de verifier et transmettre les données. Tout bug est donc de la responsbilité de l'application
        var reponse = "error"
        let urlString = "http://\(adresseIPServeur)/api/returnAllData.php"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let postString = "Nom=\(nom)&Mdp=\(mdpHashed)"
        let url = URL(string: urlString)
        request.httpBody = postString.data(using: .utf8)
        print("url \(String(describing: url))")
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in // On load le PHP
            if error != nil {
                print("******ERROR FATAL. URL NON FONCTIONNEL. ECHEC : \(String(describing: error))")
                
                serveurReponse = error!.localizedDescription
                
                
            } else { // Si aucune erreur n'est survenu
                if let JSONObject = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray{ // On enregsitre le tableau total en JSON
                        for informations in JSONObject {
                            if let information = informations as? NSDictionary { // On transforme le tableau total en dictionnaires
                                //Pour une raison qui m'est obscure, les informations ne seront pas classés dans cet ordre ...
                                var temporaryDictionnary: [String:String] = [:] // tableau temporaire qui sert à convertir les données avant de les enregsitrer
                                temporaryDictionnary.updateValue(information.value(forKey: "id") as! String, forKey: "id")
                                temporaryDictionnary.updateValue(information.value(forKey: "Nom") as! String, forKey: "Nom")
                                temporaryDictionnary.updateValue(information.value(forKey: "Statut") as! String, forKey: "Statut")
                                temporaryDictionnary.updateValue(information.value(forKey: "DateNaissance") as! String, forKey: "dateNaissance")
                                temporaryDictionnary.updateValue(information.value(forKey: "Classe") as! String, forKey: "Classe")
                                temporaryDictionnary.updateValue(information.value(forKey: "PointFidelite") as! String, forKey: "PointFidelite")
                                self.allInfo.append(temporaryDictionnary) // et on ajoute notre nouveau dico au tableau général
                                reponse = "success"
                            }
                        }
                    
                    
                } else if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    print("string")
                    //let pageConnexion = ConnexionAdmin()
                    
                    if result as String == "Autorisation refusée" { //Si la connexion est refusée
                        reponse = "permission refusée"
                    } else if result as String == "Mdp incorrect" {
                        reponse = "Mdp incorrect"
                    }
                }
                OperationQueue.main.addOperation({ // Une fois l'action effectuée on envoie le resultat
                    if reponse == "success" {// On stock les infos
                        infosAllAdherent = self.allInfo
                    }
                    serveurReponse = reponse
                })
            }
        }).resume()
        
    }
    
    //Gère la connexion d'un adhérent simple :
    public func adherentConnexion(nom: String, dateNaissance: String){
        //ATTENTION : Les données transmises par l'URL doivent être sûr. Il doit bien s'agir d'un nom suivit d'un prénom, et d'une date de la forme YYYY-MM-DD
        //Les caractères spéciaux devront être remplacés
        //L'API se charge juste de verifier et transmettre les données. Tout bug est donc de la responsbilité de l'application
        
        var reponse = "error"
        let urlString = "http://\(adresseIPServeur)/api/infoAdherent.php"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let postString = "Nom=\(nom)&DateNaissance=\(dateNaissance)"
        request.httpBody = postString.data(using: .utf8)
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in // On load le PHP
                if error != nil {
                    print("******ERROR FATAL. URL NON FONCTIONNEL. ECHEC : \(String(describing: error))")
                    
                    serveurReponse = error!.localizedDescription
                    
                    
                } else { // Si aucune erreur n'est survenu
                    
                    if let allDataUser = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray{ // On enregsitre le tableau total en JSON
                            let dataUser: NSDictionary = allDataUser[0] as! NSDictionary // On a qu'une seule valeur -> voir API
                            //Pour une raison qui m'est obscure, les informations ne seront pas classés dans cet ordre ...
                            var temporaryDictionnary: [String:String] = [:] // tableau temporaire qui sert à convertir les données avant de les enregsitrer
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "id") as! String, forKey: "id")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Nom") as! String, forKey: "Nom")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Statut") as! String, forKey: "Statut")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "DateNaissance") as! String, forKey: "DateNaissance")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Classe") as! String, forKey: "Classe")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "PointFidelite") as! String, forKey: "PointFidelite")
                            self.allInfo = [temporaryDictionnary] // et on ajoute notre nouveau dico au tableau général
                            print("all info = \(self.allInfo)")
                            reponse = "success"
                        
                        } else if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                            
                            if result as String == "Élève introuvable" { //Si la connexion est refusée
                                reponse = "Élève introuvable"
                            } else if result as String == "Date de naissance incorrect" {
                                reponse = "Date de naissance incorrect"
                            }
                        }
                    OperationQueue.main.addOperation({ // Une fois l'action effectuée on envoie le resultat
                        infosAdherent = self.allInfo[0] //On stock dans le tableau temporaire
                        
                        //On enregistre les données dans le local :
                        let localData = LocalData()
                        localData.stockDataTo(stockInfosAdherent)
                        
                        serveurReponse = reponse
                    })
                    
                }
            }).resume()
    }
    
    
    //Gère la connexion d'un admin avec ses infos de bases simples :
    public func adminConnexion(nom: String, mdpHashed: String){
        //ATTENTION : Les données transmises par l'URL doivent être sûr. Il doit bien s'agir d'un nom suivit d'un prénom, et d'un mot de passe hashé
        //Les caractères spéciaux devront être remplacés
        //L'API se charge juste de verifier et transmettre les données. Tout bug est donc de la responsbilité de l'application
        
        var reponse = "error"
        let urlString = "http://\(adresseIPServeur)/api/infoAdmin.php"
        let request = NSMutableURLRequest(url: URL(string:urlString)!)
        request.httpMethod = "POST"
        let postString:String = "Nom=\(nom)&Mdp=\(mdpHashed)"
        request.httpBody = postString.data(using: .utf8)
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in // On load le PHP
                if error != nil {
                    print("******ERROR FATAL. URL NON FONCTIONNEL. ECHEC : \(String(describing: error))")
                    
                    serveurReponse = (error?.localizedDescription)!
                    
                    
                } else { // Si aucune erreur n'est survenu
                    
                    if let allDataUser = try? (JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray){ // On enregsitre le tableau total en JSON
                            let dataUser: NSDictionary = allDataUser[0] as! NSDictionary // On a qu'une seule valeur -> voir API
                            //Pour une raison qui m'est obscure, les informations ne seront pas classés dans cet ordre ...
                            var temporaryDictionnary: [String:String] = [:] // tableau temporaire qui sert à convertir les données avant de les enregsitrer
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "id") as! String, forKey: "id")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Nom") as! String, forKey: "Nom")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Statut") as! String, forKey: "Statut")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "DateNaissance") as! String, forKey: "DateNaissance")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Classe") as! String, forKey: "Classe")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "PointFidelite") as! String, forKey: "PointFidelite")
                            temporaryDictionnary.updateValue(mdpHashed, forKey: "MdpHashed") //Le serveur ne nous retourne jamais de mot de passe. De plus il ne correspond pas au bon hash. On garde donc le nôtre
                            
                            self.allInfo = [temporaryDictionnary] // et on ajoute notre nouveau dico au tableau général
                            print("all info = \(self.allInfo)")
                            reponse = "success"
                        
                        } else if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                        if result as String == "Autorisation refusée" { //Si la connexion est refusée
                            reponse = "permission refusée"
                        } else if result as String == "Mdp incorrect" {
                            reponse = "Mdp incorrect"
                        }
                    }
                    OperationQueue.main.addOperation({ // Une fois l'action effectuée on envoie le resultat
                        infosAdherent = self.allInfo[0] //On stock dans le tableau temporaire
                        //On enregistre les données dans le local :
                        let localData = LocalData()
                        localData.stockDataTo(stockInfosAdherent)
                        
                        serveurReponse = reponse
                    })
                    
                }
            }).resume()
    }
    
    //Sert à convertir un text UTF8 en admissible par une URL
    //Charactères spéciaux autorisés : *$€£%ù+=?!@#&àç-
    public func convertionToHexaCode(_ letText: String) -> String{
        var text = letText
        let listeCharactereSpeciaux: [Character: String] = ["$": "%24", "€": "%80", "£": "%a3", "ù":"%C3%B9", "+":"%2b", "=":"%3d", "?":"%3f", "!":"%21", "@":"%40", "#":"%23", "&":"%26", "à":"%C3%A0", "ç":"%e7", "-":"%2d", " ":"%20", "*": "%2A", "é":"%C3%A9","è":"%C3%A8", "ê":"%C3%AA", "ë":"%EB", "ü":"%C3%BC", "û":"%C3%BB", "É":"%C3%89",  "È":"%C3%88", "Ê":"%C3%8A", "Ë":"%C3%8B", "Û":"%C3%9B", "Ü":"%C39C", "ä":"%E4"]
        for (charactere, code) in listeCharactereSpeciaux {
            if text.contains(charactere) { // Si on a un charactère spécial
                text = text.replacingOccurrences(of: String(charactere), with: code) // On le remplace par son code hexa
            }
        }
       return text
    }
    
    //Gère l'affichage des données d'un autre adhérent simple :
    public func otherAdherentData(nom: String, dateNaissance: String){
        //ATTENTION : Les données transmises par l'URL doivent être sûr. Il doit bien s'agir d'un nom suivit d'un prénom, et d'une date de la forme YYYY-MM-DD
        //Les caractères spéciaux devront être remplacés
        //L'API se charge juste de verifier et transmettre les données. Tout bug est donc de la responsbilité de l'application
        
        var reponse = "Une erreur est survenue"
        let urlString = "http://\(adresseIPServeur)/api/infoAdherent.php"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let postString:String = "Nom=\(nom)&DateNaissance=\(dateNaissance)"
        request.httpBody = postString.data(using: .utf8)
        
        if URL(string: urlString) != nil {
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in // On load le PHP
                if error != nil {
                    print("******ERROR FATAL. URL NON FONCTIONNEL. ECHEC : \(String(describing: error))")
                    
                    serveurReponse = error!.localizedDescription
                    
                    
                } else { // Si aucune erreur n'est survenu
                    
                    if let allDataUser = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray{ // On enregsitre le tableau total en JSON
                            let dataUser: NSDictionary = allDataUser[0] as! NSDictionary // On a qu'une seule valeur -> voir API
                            //Pour une raison qui m'est obscure, les informations ne seront pas classés dans cet ordre ...
                            var temporaryDictionnary: [String:String] = [:] // tableau temporaire qui sert à convertir les données avant de les enregsitrer
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "id") as! String, forKey: "id")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Nom") as! String, forKey: "Nom")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Statut") as! String, forKey: "Statut")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "DateNaissance") as! String, forKey: "DateNaissance")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Classe") as! String, forKey: "Classe")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "PointFidelite") as! String, forKey: "PointFidelite")
                        temporaryDictionnary.updateValue(dataUser.value(forKey: "HaveCodeTemporaire?") as! String, forKey: "HaveCodeTemporaire?")
                            
                            self.allInfo = [temporaryDictionnary] // et on ajoute notre nouveau dico au tableau général
                            print("all info = \(self.allInfo)")
                            reponse = "success"
                        } else if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                            
                            if result as String == "Élève introuvable" { //Si la connexion est refusée
                                reponse = "Élève introuvable"
                            } else if result as String == "Date de naissance incorrect" {
                                reponse = "Date de naissance incorrect"
                            }
                        }
                    OperationQueue.main.addOperation({ // Une fois l'action effectuée on envoie le resultat
                        print("result message = \(reponse)")
                        infosOtherAdherent = self.allInfo[0] //On stock dans le tableau temporaire
                        serveurReponse = reponse
                    })
                    
                }
            }).resume()
        } else { //bug dans l'URL
            print("url = nil")
            serveurReponse = "Les informations saisies semblent comporter des caractères inconnus"
        }
    }
    
    /*----------------------------------------------------------------------------------------------
                                   Code temporaire confidentiel
     ---------------------------------------------------------------------------------------------*/
    public func checkCodeTemporaire(nom: String, codeTemporaire: String){
        let url = "http://\(adresseIPServeur)/api/checkCodeTemporaire.php"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "Nom=\(nom)&CodeTemporaire=\(codeTemporaire)"
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    if result as String == "Accès au serveur refusé" { //Si la connexion est refusée
                        serveurReponse = "Accès au serveur refusé"
                    } else if result as String == "Success"{
                        serveurReponse = "success"
                    }else if result as String == "Aucun code temporaire"{
                        serveurReponse = "Aucun code temporaire"
                    } else if result as String == "Code temporaire faux"{
                        serveurReponse = "Code temporaire faux"
                    } else {
                        serveurReponse = "Une erreur inconnue est survenue lors de la connexion au serveur."
                    }
                } else {
                    serveurReponse = "Une erreur inconnue est survenue et empêche la connexion au serveur"
                    reponseURLRequestImage = "Une erreur inconnue est survenue et empêche la connexion au serveur"
                }
            }
        }).resume()
    }
    
/*###############################################################################################
 Lorsque l'on bloque l'accès à un utilisateur, à cause du nombre de tentative abusée des mots de passes
     on récupère l'heure de Paris par API afin de ne pas pouvoir tricher en changeant l'heure du téléphone ;)
     la clé de connexion est gardée privée
###############################################################################################*/
    
    public func returnLocalHours(returnDate: Bool, nbrError : Int) {
        var reponse = "error"
        let urlString = "http://api.timezonedb.com/v2.1/get-time-zone?key=\(APIKeyDate)&format=json&by=zone&zone=Europe/Paris"
        let url = URL(string: urlString)
        
        if url != nil {
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in // On load le PHP
                if error != nil {
                    print("******ERROR FATAL. URL NON FONCTIONNEL. ECHEC : \(String(describing: error))")
                    
                    serveurReponse = error!.localizedDescription
                    
                } else { // Si aucune erreur n'est survenu
                    if let JSONInfo = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{ 
                        print("JSON =\(JSONInfo)")
                        if JSONInfo.value(forKey: "status") as! String == "OK"{ //API fonctionnelle et résultat affiché
                            if !returnDate {
                                let minutesAdded = (nbrError / 5) * 5 //Cb de minutes on rajoute : 7 erreur = 2*15 = 30 min d'attente
                                print("minute added = \(nbrError / 5)")
                                
                                let dateFormatteur = DateFormatter()
                                dateFormatteur.dateFormat = "YYYY-MM-dd HH:mm:ss"
                                let actualDate = dateFormatteur.date(from: JSONInfo.value(forKey: "formatted") as! String)
                                
                                
                                var date = actualDate?.addingTimeInterval(7200)
                                if minutesAdded > 7200 { // Temps supéreieur à 2h = valeur maximale pour le blocage
                                    date = actualDate?.addingTimeInterval(7200)
                                } else {
                                    print("minutes added = \(minutesAdded * 60)")
                                    date = actualDate?.addingTimeInterval(TimeInterval(minutesAdded * 60))
                                }
                                print("\n\nActual date = \(String(describing: actualDate))")
                                print("New date = \(String(describing: date))")
                                let file = FileManager.default
                                file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(nextDateConnexionAllowed).path, contents: String(dateFormatteur.string(from: date!)).data(using: String.Encoding.utf8), attributes: nil)
                                serveurReponse = "success"
                            } else { // on demande juste d'enregistré la date actuel
                                currentDate = JSONInfo.value(forKey: "formatted") as! String
                                serveurReponse = "success"
                            }
                            
                        } else {
                            serveurReponse = "Serveur HS"
                        }
                    } else {
                        serveurReponse = "Erreur inconnu"
                    }
                }
            }).resume()
        } else { //bug dans l'URL
            reponse =  "Veuillez verifier les informations de connexions"
        }
    
    }
}
