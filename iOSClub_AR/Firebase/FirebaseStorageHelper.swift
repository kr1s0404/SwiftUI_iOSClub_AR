//
//  FirebaseStorageHelper.swift
//  iOSClub_AR
//
//  Created by Kris on 12/13/21.
//

import Foundation
import Firebase

class FirebaseStorageHelper
{
    static private let firebaseStorage = Storage.storage()
    
    class func asyncDownloadToFileSystem(relativePath: String, handler: @escaping (_ fileURL: URL) -> Void)
    {
        // 創建一個本地的儲存位置
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docsURL.appendingPathComponent(relativePath)
        
        // 判斷文件是否在本地端，如果是的話，就加載並返回
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            handler(fileURL)
            return
        }
        
        // 創建一個參考(reference)
        let storageRef = firebaseStorage.reference(withPath: relativePath)
        
        // 下載文件到本地端
        storageRef.write(toFile: fileURL) { url, error in
            guard let localURL = url else {
                print("該文件無法下載 \(relativePath)")
                return
            }
            
            handler(localURL)
        }.resume()
    }
}
