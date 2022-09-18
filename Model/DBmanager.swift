//
//  Database1.swift
//  FinalDocumentScanner
//
//  Created by MacBook Pro Retina on 29/12/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import SQLite3

class DBmanager: NSObject {
    var DBpath: String!
    var db : OpaquePointer!
    
    static let shared = DBmanager()
    
    func  manageDBLocation() {
        do {
            let bundle = Bundle.main
            DBpath = bundle.path(forResource: "ImageEditInfo", ofType: "db")
            let newPath:Array=NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let directory:String=newPath[0]
            let location = (directory as NSString).appendingPathComponent("ImageEditInfo.db") as NSString
            if(FileManager.default.isReadableFile(atPath: DBpath))
            {
                
                try FileManager.default.copyItem(atPath: DBpath as String, toPath: location as String)
            }
            let fm = FileManager.default

            var attributes = [FileAttributeKey : Any]()
            attributes[.posixPermissions] = NSNumber(value: 511)
            do {
                try fm.setAttributes(attributes, ofItemAtPath: DBpath)
            } catch let error {
                print("Permissions error: ", error)
            }
            
        } catch let e {
            print("error: \(e)")
        }
    }
    
    func initDB() -> Bool{
        let path: Array = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true
        )
        
        let directory: String = path[0]
        DBpath = (directory as NSString).appendingPathComponent("ImageEditInfo.db")
        
        
        let isSuccess = true
        
        if (!FileManager.default.fileExists(atPath: DBpath as String)) {
            self.manageDBLocation()
        }
        
        return isSuccess;
    }
    
    func deleteFile(id: String) {
        let stmt = "DELETE FROM  ImageInfo  where id = ('\(id)')"
        let  rc = sqlite3_open_v2(DBpath, &db, SQLITE_OPEN_READWRITE , nil);
        
        if (SQLITE_OK != rc) {
            sqlite3_close(db);
            NSLog("Failed to open db connection");
        }
        else {
            if sqlite3_exec(db, stmt, nil, nil, nil)  != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog(errmsg)
            }
            sqlite3_close(db);
        }
        
        
    }
    
    func deleteSticker(id: String) {
        let stmt = "DELETE FROM  StickerInfo  where id = ('\(id)')"
        
        let  rc = sqlite3_open_v2(DBpath, &db, SQLITE_OPEN_READWRITE , nil);
        
        
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog("Failed to open db connection");
        }
        else
        
        {
            
            
            if sqlite3_exec(db, stmt, nil, nil, nil)  != SQLITE_OK
                
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog(errmsg)
            }
            sqlite3_close(db);
        }
        
        
    }

    func updateTableData(id: String,fileObj: ImageInfoData) {
        let createTable = "UPDATE ImageInfo SET OverLay='\(fileObj.OverLay)', ov='\(fileObj.ov)', Bri='\(fileObj.Bri)',Sat='\(fileObj.Sat)',Cont='\(fileObj.Cont)',filter='\(fileObj.filter)' WHERE id='\(id)'"
    
        
        if (sqlite3_open(DBpath, &db)==SQLITE_OK) {
            if sqlite3_exec(db, createTable, nil, nil, nil)  != SQLITE_OK {
                print("Erro creating table")
            }
        }
        
        sqlite3_close(db)
    }
    
    func updateTextData(fileNAME: String, fileObj: TextInfoData) {
        let createTable = "UPDATE TextInfo SET font='\(fileObj.font)', color='\(fileObj.color)',gradient='\(fileObj.gradient)',texture='\(fileObj.texture)',opacity='\(fileObj.opacity)',shadow='\(fileObj.shadow)',align='\(fileObj.align)',center='\(fileObj.align)',text='\(fileObj.text)' WHERE file='\(fileNAME)'"
        
        if sqlite3_open(DBpath, &db) == SQLITE_OK {
            if sqlite3_exec(db, createTable, nil, nil, nil)  != SQLITE_OK {
                print("Erro creating table")
            }
        }
        
        sqlite3_close(db)
    }
    
    func updateStickerData(id: String,fileObj: StickerValueObj) {
        let createTable = "UPDATE StickerInfo SET x='\(fileObj.x)', y='\(fileObj.y)', width='\(fileObj.width)',height='\(fileObj.height)',inset='\(fileObj.inset)',centerx='\(fileObj.centerx)',centery='\(fileObj.centery)' WHERE id='\(id)'"
        
        if (sqlite3_open(DBpath, &db)==SQLITE_OK) {
            if sqlite3_exec(db, createTable, nil, nil, nil)  != SQLITE_OK {
                print("Erro creating table")
            }
        }
        sqlite3_close(db)
    }
    
    
    func insertTextFile(fileObj: TextInfoData) {
        let insertData = "INSERT INTO TextInfo (file,font,color,gradient,texture,opacity,shadow,align,rotate,text) VALUES  ('\(fileObj.file)','\(fileObj.font)','\(fileObj.color)','\(fileObj.gradient)','\(fileObj.texture)','\(fileObj.opacity)','\(fileObj.shadow)','\(fileObj.align)','\(fileObj.rotate)','\(fileObj.text)')"
        
        let  rc = sqlite3_open_v2(DBpath, &db, SQLITE_OPEN_READWRITE , nil);
        

        if (SQLITE_OK != rc) {
            sqlite3_close(db);
            NSLog("Failed to open db connection");
        }
        else {
            if sqlite3_exec(db, insertData, nil, nil, nil)  != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog(errmsg)
            }
            
            sqlite3_close(db);
        }
    }
    
    
    func insertStickerile(fileObj: StickerValueObj) {
        let insertData = "INSERT INTO StickerInfo (FileName,x,y,width,height,inset,type,pathName,centerx,centery) VALUES  ('\(fileObj.fileName)','\(fileObj.x)','\(fileObj.y)','\(fileObj.width)','\(fileObj.height)','\(fileObj.inset)','\(fileObj.type)','\(fileObj.pathName)','\(fileObj.centerx)','\(fileObj.centery)')"
        
        let  rc = sqlite3_open_v2(DBpath, &db, SQLITE_OPEN_READWRITE , nil);
        
        
        if (SQLITE_OK != rc) {
            sqlite3_close(db);
            NSLog("Failed to open db connection");
        }
        else {
            if sqlite3_exec(db, insertData, nil, nil, nil)  != SQLITE_OK
                
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog(errmsg)
            }
            sqlite3_close(db);
        }
    }
    
    
    func insertmergeFile(fileObj: ImageInfoData) {
        let insertData = "INSERT INTO ImageInfo (OverLay,Filter,Sticker,Bri,Hue,Sat,Cont,ov) VALUES  ('\(fileObj.OverLay)','\(fileObj.filter)','\(fileObj.Sticker)','\(fileObj.Bri)','\(fileObj.Hue)','\(fileObj.Sat)','\(fileObj.Cont)','\(fileObj.ov)')"
        
        let  rc = sqlite3_open_v2(DBpath, &db, SQLITE_OPEN_READWRITE , nil);
        
        
        if (SQLITE_OK != rc) {
            sqlite3_close(db);
            NSLog("Failed to open db connection");
        }
        else {
            if sqlite3_exec(db, insertData, nil, nil, nil)  != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog(errmsg)
            }
            sqlite3_close(db);
        }
    }
    
    func getTextInfo(fileName: String) -> TextInfoData {
        var mutableArray = [TextInfoData]()
        var queryStatement: OpaquePointer? = nil
        
        let stmt =  "SELECT font,color,gradient,texture,opacity,shadow,align,rotate,align,text FROM TextInfo where file = \(fileName)"
        if (sqlite3_open(DBpath, &db) == SQLITE_OK) {
            if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                    let obj : TextInfoData = TextInfoData()
                
                    let font =       sqlite3_column_text(queryStatement, 0)
                    let color =  sqlite3_column_text(queryStatement, 1)
                    let gradient =   sqlite3_column_text(queryStatement, 2)
                    let texture =  sqlite3_column_text(queryStatement, 3)
                    let opacity =      sqlite3_column_text(queryStatement, 4)
                    let shadow =      sqlite3_column_text(queryStatement, 5)
                    let rotate =     sqlite3_column_text(queryStatement, 7)
                    let align =       sqlite3_column_text(queryStatement, 8)
                    let text =       sqlite3_column_text(queryStatement, 9)
                   
                    obj.font = String(cString: font!)
                    obj.color = String(cString: color!)
                    obj.gradient = String(cString: gradient!)
                    obj.texture = String(cString: texture!)
                    obj.opacity = String(cString: opacity!)
                    obj.shadow = String(cString: shadow!)
                    obj.rotate = String(cString: rotate!)
                    obj.align = String(cString: align!)
                    obj.text = String(cString: text!)
                    
                    
                    mutableArray.append(obj)
                }
            }
            
            sqlite3_finalize(queryStatement)
            sqlite3_close(db)
        }
        
        return mutableArray[0]
    }
    
    func getStickerInfo(fileName: String) -> [StickerValueObj]{
        var mutableArray = [StickerValueObj]()
        var queryStatement: OpaquePointer? = nil
        
        let stmt =  "SELECT id,FileName,x,y,width,height,inset,type,pathName,centerx,centery FROM StickerInfo where FileName = \(fileName)"
        if (sqlite3_open(DBpath, &db)==SQLITE_OK) {
            if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                    let obj : StickerValueObj = StickerValueObj()
                
                    let id =       sqlite3_column_text(queryStatement, 0)
                    let OverLay =  sqlite3_column_text(queryStatement, 1)
                    let Filter =   sqlite3_column_text(queryStatement, 2)
                    let Sticker =  sqlite3_column_text(queryStatement, 3)
                    let Bri =      sqlite3_column_text(queryStatement, 4)
                    let Hue =      sqlite3_column_text(queryStatement, 5)
                    let Sat =      sqlite3_column_text(queryStatement, 6)
                    let Cont =     sqlite3_column_text(queryStatement, 7)
                    let ov =       sqlite3_column_text(queryStatement, 8)
                    let ov1 =      sqlite3_column_text(queryStatement, 9)
                    let ov2 =      sqlite3_column_text(queryStatement, 10)

                    obj.id = String(cString: id!)
                    obj.fileName = String(cString: OverLay!)
                    obj.x = String(cString: Filter!)
                    obj.y = String(cString: Sticker!)
                    obj.width = String(cString: Bri!)
                    obj.height = String(cString: Hue!)
                    obj.inset = String(cString: Sat!)
                    obj.type = String(cString: Cont!)
                    obj.pathName = String(cString: ov!)
                    obj.centerx = String(cString: ov1!)
                    obj.centery =  String(cString: ov2!)
                    
                    mutableArray.append(obj)
                }
                
            }
            sqlite3_finalize(queryStatement)
            sqlite3_close(db)
        }
        
        return mutableArray
    }
    
    func getMergeFolder() -> [ImageInfoData]{
        
        var mutableArray = [ImageInfoData]()
        var queryStatement: OpaquePointer? = nil
        
        
        
        let stmt =  "SELECT id,OverLay,Filter,Sticker,Bri,Hue,Sat,Cont,ov FROM ImageInfo order by id desc"
        if (sqlite3_open(DBpath, &db)==SQLITE_OK)
        {
            
            if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                
                
                while (sqlite3_step(queryStatement) == SQLITE_ROW){
                    
                    let obj : ImageInfoData = ImageInfoData()
                    
                    let id = sqlite3_column_text(queryStatement, 0)
                    
                    let OverLay =  sqlite3_column_text(queryStatement, 1)
                    let Filter =  sqlite3_column_text(queryStatement, 2)
                    let Sticker =  sqlite3_column_text(queryStatement, 3)
                    let Bri =  sqlite3_column_text(queryStatement, 4)
                    let Hue =  sqlite3_column_text(queryStatement, 5)
                    let Sat =  sqlite3_column_text(queryStatement, 6)
                    let Cont =  sqlite3_column_text(queryStatement, 7)
                    let ov =  sqlite3_column_text(queryStatement, 8)


                    
                    
                    obj.id = String(cString: id!)
                    obj.OverLay = String(cString: OverLay!)
                    obj.filter = String(cString: Filter!)
                    obj.Sticker = String(cString: Sticker!)
                    obj.Bri = String(cString: Bri!)
                    obj.Hue = String(cString: Hue!)
                    obj.Sat = String(cString: Sat!)
                    obj.Cont = String(cString: Cont!)
                    obj.ov = String(cString: ov!)
                    
        
                    mutableArray .append(obj)
                    
                }
                
            }
            sqlite3_finalize(queryStatement)
            sqlite3_close(db)
        }
        
        
        
        return mutableArray
    }
    
    
    
    func getMaxIdForMerge() ->Int{
        
        var queryStatement: OpaquePointer? = nil
        var getId  = -1
        
        let stmt =  "SELECT MAX(id) FROM ImageInfo"
        
        if (sqlite3_open(DBpath, &db)==SQLITE_OK) {
            if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                // 2
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                    
                    
                    
                    let id = sqlite3_column_text(queryStatement, 0)
                    
                    if((id) != nil)
                    {
                        let str = String(cString: id!) as NSString
                        getId = Int(str.intValue)
                    }
                    
                }
                
                
                
            }
            else{
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog(errmsg)
            }
              sqlite3_finalize(queryStatement)
              sqlite3_close(db)
        }
        
        return getId
    }
}
    
     
    
