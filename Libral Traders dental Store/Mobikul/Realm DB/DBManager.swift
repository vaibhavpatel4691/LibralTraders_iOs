import Foundation
import RealmSwift

import UIKit

import RealmSwift

enum ErrorsDBManager: Error {
    case errorObjectNotCreated
    case errorOther
}

class DBManager {
    
    public var database: Realm?
    
    static let sharedInstance = DBManager()
    
    private init() {
        do {
            let databaseObject = try Realm()
            self.database = databaseObject
        } catch {
            print("Error occurred \(error)")
        }
        
    }
    
    func deleteAllFromDatabase() {
        do {
            _ =  try database?.write {
                database?.deleteAll()
                
            }
        } catch let error as NSError {
            print("ss", error)
        }
        
    }
    
    func geteTagFromDataBase(hashKey: String) -> String {
        
        var eTag: String = ""
        
        do {
            try DBManager.sharedInstance.database?.write {
                let result =  DBManager.sharedInstance.database?.object(ofType: AllDataCollection.self, forPrimaryKey: hashKey)
                if result?.eTag != nil {
                    eTag = (result?.eTag)!
                }
            }
        } catch {
            print("Error occurred \(error)")
        }
        
        return  eTag
        
    }
    
    func storeDataToDataBase(data: String, eTag: String, hashKey: String) {
        let dataBaseObject = GetHashKey.sharedInstance.getDataBaseObject()
        
        if dataBaseObject.hashKey == "" {
            dataBaseObject.hashKey = hashKey
        }
        
        do {
            try DBManager.sharedInstance.database?.write {
                dataBaseObject.data = data
                dataBaseObject.eTag = eTag
                DBManager.sharedInstance.database?.add(dataBaseObject, update: .all)
            }
        } catch {
            print("Error occurred \(error)")
        }
        
    }
    
    func getJSONDatafromDatabase(hashKey: String) -> JSON {
        
        var resultData: JSON = []
        
        do {
            try DBManager.sharedInstance.database?.write {
                let result =  DBManager.sharedInstance.database?.object(ofType: AllDataCollection.self, forPrimaryKey: hashKey)
                if let data = result?.data {
                    resultData = JSON(NetworkManager.sharedInstance.convertToDictionary(text: data) ?? [:])
                }
            }
        } catch {
            print("Error occurred \(error)")
        }
        
        return resultData
    }
    func convertToDictionary(hashKey: String) -> [String: Any]? {
        
        
        var resultData = [String:Any]()
        
        do {
            try DBManager.sharedInstance.database?.write {
                let result =  DBManager.sharedInstance.database?.object(ofType: AllDataCollection.self, forPrimaryKey: hashKey)
                if let data = result?.data {
                    if let data1 = data.data(using: .utf8) {
                        do {
                            resultData = try JSONSerialization.jsonObject(with: data1, options: []) as? [String: Any] ?? [:]
                        } catch {
                            print(error.localizedDescription)
                        }
                    }

//                    resultData = JSON(NetworkManager.sharedInstance.convertToDictionary(text: data) ?? [:])
                }
            }
        } catch {
            print("Error occurred \(error)")
        }
        
        return resultData
        
        
    }
    func deleteSpecificFromDatabase(hashKey: String) {
        do {
            _ =  try database?.write {
                if let result =  DBManager.sharedInstance.database?.object(ofType: AllDataCollection.self, forPrimaryKey: hashKey) {
                database?.delete(result)
                }
                
                
            }
        } catch let error as NSError {
            print("ss", error)
        }
        
    }
}
extension Object {
    static func deleteAll(`in` realm: Realm) throws {
        let allObjects = realm.objects(self)
        try realm.write {
            realm.delete(allObjects)
        }
    }
}
