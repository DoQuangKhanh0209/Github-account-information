//
//  CoreData.swift
//  Github-account-information
//
//  Created by Quang Khánh on 03/11/2022.
//

import UIKit
import Foundation
import CoreData

class CoreData {
    
    static let shareData = CoreData()
    private var appDelegate: AppDelegate?
    
    private init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    func addUserToCoreData(userInfo: DomainUser?) {
        guard let appDelegate = appDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: managedContext)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(userInfo?.login, forKey: "login")
        user.setValue(userInfo?.avatarUrl, forKey: "avatarUrl")
        user.setValue(userInfo?.htmlUrl, forKey: "htmlUrl")
        user.setValue(userInfo?.followersUrl, forKey: "followersUrl")
        user.setValue(userInfo?.followingUrl, forKey: "followingUrl")
        user.setValue(userInfo?.id, forKey: "id")
        user.setValue(userInfo?.reposUrl, forKey: "reposUrl")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getFavoriteUserList(completion: @escaping ([NSManagedObject], Error?) -> (Void)) {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            completion(items, nil)
        } catch let error as NSError {
            DispatchQueue.main.async {
                completion([], error)
            }
            return
        }
    }
    
    func deleteUserFromCoreData(userInfo: DomainUser?) {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if (item.value(forKey: "id") as? Int == (userInfo?.id ?? 0)) {
                    managedContext.delete(item)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

