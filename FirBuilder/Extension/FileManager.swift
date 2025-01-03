//
//  FileManager.swift
//  FirBuilder
//
//  Created by PC on 2022/2/14.
//

import Foundation



extension FileManager{

    /** 获取文件大小，带单位 */
    func sizeWithFilePath(filePath:String) -> String{
        let size = sizeForLocalFilePath(filePath: filePath)
        return covertSizeToFileString(with: size)
    }

    /** 获取文件大小， UInt64*/
    func sizeForLocalFilePath(filePath:String) -> UInt64 {
        do {
            let fileAttributes = try self.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }

    /** 转换文件大小到具体单位 */
    func covertSizeToFileString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }

}
