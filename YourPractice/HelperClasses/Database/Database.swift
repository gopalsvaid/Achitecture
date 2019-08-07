//
//  Database.swift
//  YourPractice
//
//  Created by Devangi Shah on 27/02/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit
import SwiftyJSON
import FMDB

// database response handler blocks.
typealias successBlockDB  =  ((_ isSuccess: Bool? ) ->  (Void))

/**
 Create Class of Database methods
 */
class Database: NSObject {

     //MARK:- Create share Instance of Database class
    static let sharedInstance = Database()
    
    //MARK:- Create object of FMDB
    var fmdb = FMDatabase()
    
    //MARK:- Open DB
    func openDB() {
        fmdb = FMDatabase(path: getDocumentPath(withFileName: kDATABASENAME))
    }
    
    //MARK:- get the database file path
    func getDocumentPath(withFileName fileName: String) -> String{
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let finalDatabaseURL = documentsUrl?.appendingPathComponent(fileName)
        do {
            if !fileManager.fileExists(atPath: (finalDatabaseURL?.path)!) {
                print("DB does not exist in documents folder")
                let arrSqliteDB = fileName.components(separatedBy: ".")
                if let dbFilePath = Bundle.main.path(forResource: arrSqliteDB[0], ofType:arrSqliteDB[1]) {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: (finalDatabaseURL?.path)!)
                } else {
                    print("db is not in the app bundle")
                }
            } else {
                print("Database file found at path: \(String(describing: finalDatabaseURL?.path))")
            }
        } catch {
            print("Unable to copy db: \(error)")
        }
        return (finalDatabaseURL?.absoluteString)!
    }
    
    //MARK:- create a database
    func createTableInDataBase(){
        if checkTableExistOrNot(withTablename: DBTable.kUSERSTABLE) == false {
            creatTableForUsersData(success: { (isSuccess) -> (Void) in
            })
        }
    }
    
    //MARK:- check Table Exists or Not from DB
    func checkTableExistOrNot(withTablename tableName: String) -> Bool{
        objc_sync_enter(self)
        var isExist = Bool()
        if fmdb.open()
        {
            if fmdb.beginTransaction(){
                if !fmdb.tableExists(tableName) {
                    isExist = false
                }else {
                    isExist = true
                }
                fmdb.commit()
                fmdb.close()
            }
        }
        objc_sync_exit(self);
        return isExist
    }
    
    //MARK: - Create table methode for event list store
    func creatTableForUsersData(success: @escaping successBlockDB) {
        objc_sync_enter(self)
        if fmdb.open(){
            if fmdb.beginTransaction(){
                let tblUsers = "CREATE TABLE \(DBTable.kUSERSTABLE) (\(DBColumn.kWSEMAIL) TEXT, \(DBColumn.kWSLASTNAME) TEXT, \(DBColumn.kWSUSERID) TEXT PRIMARY KEY, \(DBColumn.kWSFIRSTNAME) TEXT)"
                do {
                    try fmdb.executeUpdate(tblUsers, values: nil)
                    success(true)
                }catch {
                    print("Could not create table.")
                    print(error.localizedDescription)
                    success(false)
                }
            }else {
                success(false)
            }
            fmdb.commit()
            fmdb.close()
        } else {
            success(false)
        }
        objc_sync_exit(self);
    }
 
     //MARK:- check number of rows exist or not in table
    func checkNumberOfRowsExistOrNot(withTablename tableName: String) -> Bool
    {
        objc_sync_enter(self)
        var isSuccess : Bool = true
        if fmdb.open(){
            if fmdb.beginTransaction(){
                let selectQuery = "select * from \(tableName)"
                do{
                    let results = try fmdb.executeQuery(selectQuery, values: nil)
                    while results.next()
                    {
                      isSuccess = true
                    }
                } catch {
                    print(error.localizedDescription)
                }
                fmdb.commit()
                fmdb.close()
            }
        }
        objc_sync_exit(self);
        return isSuccess
    }
    //MARK: - Insert Array data in database
    func insertArrayData(tblName: String ,arrData: JSON,success: @escaping successBlockDB)
    {
        objc_sync_enter(self)
        if fmdb.open(){
            if fmdb.beginTransaction() {
                
                for dictData in arrData {
                    
                    if dictData.1 == JSON.null {
                        success(false)
                        fmdb.commit()
                        fmdb.close()
                        return
                    }
                    var removeNullDict : Dictionary = (dictData.1.dictionaryObject?.dictionaryByReplacingNullsWithStrings())!
                    
                    let keyarr = Array(removeNullDict.keys)
                    let valuearr = Array(removeNullDict.values)
                    
                    var insertqry: String = "insert or replace into \(tblName) ("
                    for i in 0..<keyarr.count {
                        if i < keyarr.count - 1 {
                            insertqry = "\(insertqry) \(keyarr[i]),"
                        } else {
                            insertqry = "\(insertqry) \(keyarr[i])"
                        }
                    }
                    insertqry = insertqry + (") values (")
                    for j in 0..<valuearr.count {
                        if j < valuearr.count - 1 {
                            insertqry = "\(insertqry) \"\(valuearr[j])\","
                        } else {
                            insertqry = "\(insertqry) \"\(valuearr[j])\""
                        }
                    }
                    insertqry = insertqry + (")")
                    
                    if fmdb.executeStatements(insertqry) {
                        if Int(dictData.0) == arrData.count - 1 {
                            fmdb.commit()
                            fmdb.close()
                            success(true)
                        }
                        // print("succesfull insert initial data into the database.")
                    } else {
                        if fmdb.lastError().localizedDescription.contains("has no column named") {
                            if let strColumnName = fmdb.lastError().localizedDescription.components(separatedBy: " ").last {
                                let alterQry = "ALTER TABLE \(tblName) ADD COLUMN \(strColumnName) TEXT"
                                if fmdb.executeStatements(alterQry) {
                                    fmdb.commit()
                                    fmdb.close()
                                    insertArrayData(tblName: tblName, arrData: arrData, success: { (isSuccess) -> (Void) in
                                        success(isSuccess!)
                                    })
                                }else {
                                    success(false)
                                }
                            }else {
                                success(false)
                            }
                        }else {
                            success(false)
                        }
                        // print("Failed to insert initial data into the database.")
                    }
                }
            }else {
                success(false)
            }
            fmdb.commit()
            fmdb.close()
        }else {
            success(false)
        }
        objc_sync_exit(self)
    }
    
    //MARK:- update data in database
    func updateData(tblName: String , dicUpdate: Dictionary<String, Any> , dicCondition: Dictionary<String, Any>,success: @escaping successBlockDB)
    {
        if checkTableExistOrNot(withTablename: tblName){
            objc_sync_enter(self)
            if fmdb.open() {
                if fmdb.beginTransaction() {
                    
                    let updateallKeys =  Array(dicUpdate.keys)
                    let conditionKeys = Array(dicCondition.keys)
                    
                    var updateqry: String = "update \(tblName) SET "
                    
                    for i in 0..<updateallKeys.count {
                        if i == updateallKeys.count - 1 {
                            let strJoin =  "\( updateallKeys[i]) = \"\(dicUpdate[updateallKeys[i]] ?? (Any).self)\""
                            updateqry = updateqry + (strJoin)
                        } else {
                            let strJoin = "\( updateallKeys[i]) = \"\(dicUpdate[updateallKeys[i]] ?? (Any).self)\","
                            updateqry = updateqry + (strJoin)
                        }
                    }
                    
                    for j in 0..<conditionKeys.count {
                        if j == 0 {
                            updateqry = updateqry + " where \( conditionKeys[j]) = \"\(dicCondition[conditionKeys[j]] ?? (Any).self)\""
                        } else {
                            updateqry = updateqry + " and \( conditionKeys[j]) = \(dicCondition[conditionKeys[j]] ?? (Any).self)"
                        }
                    }
                    do {
                        try fmdb.executeUpdate(updateqry, values: nil)
                        fmdb.commit()
                        fmdb.close()
                        success(true)
                        print("Data Update Successfully" )
                    } catch {
                        fmdb.commit()
                        fmdb.close()
                        success(false)
                        print(error.localizedDescription)
                    }
                    fmdb.commit()
                    fmdb.close()
                }else {
                    success(false)
                }
            }else {
                success(false)
            }
            objc_sync_exit(self)
        }
    }
    
    //MARK:- delete data in database
    func deleteData(withtableName tblName: String,strQuery qry  :String,success: @escaping successBlockDB)
    {
        if checkTableExistOrNot(withTablename: tblName){
            objc_sync_enter(self)
            if fmdb.open(){
                if fmdb.beginTransaction() {
                    var deleteqry: String = "DELETE FROM \(tblName)"
                    if !qry.isEmpty {
                        deleteqry = "\(deleteqry) where \(qry)"
                    }
                    if fmdb.executeStatements(deleteqry) {
                        fmdb.commit()
                        fmdb.close()
                        success(true)
                    }else {
                        fmdb.commit()
                        fmdb.close()
                        success(false)
                    }
                }else {
                    success(false)
                }
            }else {
                success(false)
            }
            objc_sync_exit(self);
        }
    }
    
    //MARK:- get User data from DB
    func getUserDetailFromDatabase(withtableName tblName: String,strQuery qry  :String) -> UserData
    {
        objc_sync_enter(self)
        var userDetail = UserData()
        if fmdb.open(){
            if fmdb.beginTransaction(){
                
                var selectQuery = "select * from \(tblName)"
                
                if qry.count > 0 {
                    selectQuery = "\(selectQuery) where \(qry)"
                }
                do{
                    let results = try fmdb.executeQuery(selectQuery, values: nil)
                    while results.next()
                    {
                        userDetail = UserData(strUserId: results.string(forColumn: DBColumn.kWSUSERID), strEmail: results.string(forColumn: DBColumn.kWSEMAIL), strFirstName: results.string(forColumn: DBColumn.kWSFIRSTNAME), strLastName: results.string(forColumn: DBColumn.kWSLASTNAME))
                    }
                } catch {
                    print(error.localizedDescription)
                }
                fmdb.commit()
                fmdb.close()
            }
        }
        objc_sync_exit(self);
        return userDetail
    }
    
    //MARK:- get single value in DB
    func findSingleValue(withTablename tableName: String ,fieldName fN: String ,query strQuery : String) -> String
    {
        var strValue = ""
        objc_sync_enter(self)
        if fmdb.open(){
            if fmdb.beginTransaction(){
                var strForQuery: String = ""
                
                if strQuery.count > 0{
                    strForQuery = "SELECT \(fN) FROM \(tableName) where \(strQuery)"
                }else{
                    strForQuery = "SELECT \(fN) FROM \(tableName)"
                }
                // let strForQuery: String = "SELECT  \(fN) FROM \(tableName) where \(strQuery)"
                do {
                    let results : FMResultSet = try fmdb.executeQuery(strForQuery, values: nil)
                    if results.next() == true{
                        if results.object(forColumnIndex: 0) is Int {
                            strValue = "\(results.object(forColumnIndex: 0) ?? "")"
                        } else {
                            strValue = results.object(forColumnIndex: 0) as! String
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                fmdb.commit()
                fmdb.close()
            }
        }
        objc_sync_exit(self);
        return strValue
    }
    
    //MARK:- insert json data in DB
    
    func insertJsonData(tblName: String ,apiName : String,jsonData: JSON,isDeletePreviousData : Bool,success: @escaping successBlockDB)
    {
        var parameters = [String:AnyObject]()
        parameters[DBColumn.kAPINAME] =  apiName as AnyObject
        parameters[DBColumn.kJSONRESPONSE] = jsonData as AnyObject
        parameters[DBColumn.kVERSION] = "" as AnyObject
        parameters[DBColumn.kUPDATETIME] = "" as AnyObject
        
        if isDeletePreviousData{
            Database.sharedInstance.deleteData(withtableName: tblName, strQuery: "", success: { (isSuccess) -> (Void) in
            })
        }
        Database.sharedInstance.insertArrayData(tblName: tblName, arrData: JSON(parameters), success: { (isSuccess) -> (Void) in
            
        })
    }
}
