//
//  HashCode.swift
//  FirBuilder
//
//  Created by PC on 2022/2/8.
//

import Foundation
import CommonCrypto




// MARK: FileHash 计算文件相关的哈希值
@objcMembers class FileHash: NSObject {
    private enum hashType{
        case md5
        case sha1
        case sha256
        case sha384
        case sha512
    }

    public static func md5WithPath(path:String) -> String{
        return self.md5WithURL(url:URL(fileURLWithPath: path))
    }

    public static func md5WithURL(url:URL) -> String{
        let bufferSize = 1024 * 1024
        do {
            // Open file for reading:
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }

            // Create and initialize MD5 context:
            var context = CC_MD5_CTX()
            CC_MD5_Init(&context)

            // Read up to `bufferSize` bytes, until EOF is reached, and update MD5 context:
            while autoreleasepool(invoking: {
                let data = file.readData(ofLength: bufferSize)
                if data.count > 0 {
    //                data.withUnsafeBytes {
    //                    _ = CC_MD5_Update(&context, $0, numericCast(data.count))
    //                }
                    data.withUnsafeBytes { (rawBuffer) -> Void in
                        let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                        let unsafePointer = unsafeBufferPointer.baseAddress
                        CC_MD5_Update(&context, unsafePointer, numericCast(data.count))
                    }
                    return true // Continue
                } else {
                    return false // End of file
                }
            }) { }

            // Compute the MD5 digest:
            var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))

    //        //deprecated func
    //        digest.withUnsafeMutableBytes {
    //            _ = CC_MD5_Final($0, &context)
    //        }
            digest.withUnsafeMutableBytes { (rawBuffer) -> Void in
                let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                let unsafePointer = unsafeBufferPointer.baseAddress
                CC_MD5_Final(unsafePointer, &context)
            }
            return digestHashString(digest)

        } catch {
            print(error)
            return ""
        }
    }

    public static func sha1WithPath(path:String) -> String {
        return self.sha1WithURL(url: URL(fileURLWithPath: path))
    }


    public static func sha1WithURL(url:URL) -> String {
        do {
            let bufferSize = 1024 * 1024
            // Open file for reading:
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }

            // Create and initialize SHA256 context:
            var context = CC_SHA1_CTX()
            CC_SHA1_Init(&context)

            // Read up to `bufferSize` bytes, until EOF is reached, and update SHA256 context:
            while autoreleasepool(invoking: {
                // Read up to `bufferSize` bytes
                let data = file.readData(ofLength: bufferSize)
                if data.count > 0 {
                    data.withUnsafeBytes { (rawBuffer) -> Void in
                        let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                        let unsafePointer = unsafeBufferPointer.baseAddress
                        CC_SHA1_Update(&context, unsafePointer, numericCast(data.count))
                    }
                    // Continue
                    return true
                } else {
                    // End of file
                    return false
                }
            }) { }

            // Compute the SHA256 digest:
            var digest = Data(count: Int(CC_SHA1_DIGEST_LENGTH))

            digest.withUnsafeMutableBytes { (rawBuffer) -> Void in
                let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                let unsafePointer = unsafeBufferPointer.baseAddress
                CC_SHA1_Final(unsafePointer, &context)
            }

            return digest.map { String(format: "%02hhx", $0) }.joined()
        } catch {
            print(error)
            return ""
        }
    }

    public static func sha256WithPath(path:String) -> String {
        return self.sha256WithURL(url: URL(fileURLWithPath: path))
    }

    public static func sha256WithURL(url:URL) -> String {
        do {
            let bufferSize = 1024 * 1024
            // Open file for reading:
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }

            // Create and initialize SHA256 context:
            var context = CC_SHA256_CTX()
            CC_SHA256_Init(&context)

            // Read up to `bufferSize` bytes, until EOF is reached, and update SHA256 context:
            while autoreleasepool(invoking: {
                // Read up to `bufferSize` bytes
                let data = file.readData(ofLength: bufferSize)
                if data.count > 0 {
                    data.withUnsafeBytes { (rawBuffer) -> Void in
                        let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                        let unsafePointer = unsafeBufferPointer.baseAddress
                        CC_SHA256_Update(&context, unsafePointer, numericCast(data.count))
                    }
                    // Continue
                    return true
                } else {
                    // End of file
                    return false
                }
            }) { }

            // Compute the SHA256 digest:
            var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

            digest.withUnsafeMutableBytes { (rawBuffer) -> Void in
                let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                let unsafePointer = unsafeBufferPointer.baseAddress
                CC_SHA256_Final(unsafePointer, &context)
            }

            return digest.map { String(format: "%02hhx", $0) }.joined()
        } catch {
            print(error)
            return ""
        }
    }

    public static func sha384WithPath(path:String) -> String {
        return self.sha384WithURL(url: URL(fileURLWithPath: path))
    }

    public static func sha384WithURL(url: URL) -> String {
        do {
            let bufferSize = 1024 * 1024
            // Open file for reading:
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }

            // Create and initialize SHA256 context:
            var context = CC_SHA512_CTX()
            CC_SHA384_Init(&context)

            // Read up to `bufferSize` bytes, until EOF is reached, and update SHA256 context:
            while autoreleasepool(invoking: {
                // Read up to `bufferSize` bytes
                let data = file.readData(ofLength: bufferSize)
                if data.count > 0 {
                    data.withUnsafeBytes { (rawBuffer) -> Void in
                        let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                        let unsafePointer = unsafeBufferPointer.baseAddress
                        CC_SHA384_Update(&context, unsafePointer, numericCast(data.count))
                    }
                    // Continue
                    return true
                } else {
                    // End of file
                    return false
                }
            }) { }

            // Compute the SHA256 digest:
            var digest = Data(count: Int(CC_SHA384_DIGEST_LENGTH))

            digest.withUnsafeMutableBytes { (rawBuffer) -> Void in
                let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                let unsafePointer = unsafeBufferPointer.baseAddress
                CC_SHA384_Final(unsafePointer, &context)
            }

            return digest.map { String(format: "%02hhx", $0) }.joined()
        } catch {
            print(error)
            return ""
        }
    }

    public static func sha512WithPath(path:String) -> String {
        return self.sha512WithURL(url: URL(fileURLWithPath: path))
    }


    public static func sha512WithURL(url: URL) -> String {
        do {
            let bufferSize = 1024 * 1024
            // Open file for reading:
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }

            // Create and initialize SHA256 context:
            var context = CC_SHA512_CTX()
            CC_SHA512_Init(&context)

            // Read up to `bufferSize` bytes, until EOF is reached, and update SHA256 context:
            while autoreleasepool(invoking: {
                // Read up to `bufferSize` bytes
                let data = file.readData(ofLength: bufferSize)
                if data.count > 0 {
                    data.withUnsafeBytes { (rawBuffer) -> Void in
                        let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                        let unsafePointer = unsafeBufferPointer.baseAddress
                        CC_SHA512_Update(&context, unsafePointer, numericCast(data.count))
                    }
                    // Continue
                    return true
                } else {
                    // End of file
                    return false
                }
            }) { }

            // Compute the SHA256 digest:
            var digest = Data(count: Int(CC_SHA512_DIGEST_LENGTH))

            digest.withUnsafeMutableBytes { (rawBuffer) -> Void in
                let unsafeBufferPointer = rawBuffer.bindMemory(to: UInt8.self)
                let unsafePointer = unsafeBufferPointer.baseAddress
                CC_SHA512_Final(unsafePointer, &context)
            }

            return digest.map { String(format: "%02hhx", $0) }.joined()
        } catch {
            print(error)
            return ""
        }
    }

}



// MARK: FileHash 计算字符串相关的哈希值
extension FileHash{
    public static func md5(_ string:String!) -> String{
        if let str = string {
            let utf8 = str.cString(using: .utf8)
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
            return digestHashString(digest)
        }
        return ""
    }

    public static func sha1(_ string:String!) -> String{
        if let str = string {
            let utf8 = str.cString(using: .utf8)
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1(utf8, CC_LONG(utf8!.count - 1), &digest)
            return digestHashString(digest)
        }
        return ""
    }

    public static func ha256(_ string:String!) -> String{
        if let str = string {
            let utf8 = str.cString(using: .utf8)
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
            return digestHashString(digest)
        }
        return ""
    }

    public static func sha384(_ string:String!) -> String{
        if let str = string {
            let utf8 = str.cString(using: .utf8)
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH))
            CC_SHA384(utf8, CC_LONG(utf8!.count - 1), &digest)
            return digestHashString(digest)
        }
        return ""
    }

    public static func sha512(_ string:String!) -> String{
        if let str = string {
            let utf8 = str.cString(using: .utf8)
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
            CC_SHA512(utf8, CC_LONG(utf8!.count - 1), &digest)
            return digestHashString(digest)
        }
        return ""
    }
}



extension FileHash{
    //是否大写的哈希值:hash_md5，hash_sha1，...
    public static var uppercased = false

    private static func digestHashString(_ digest:Array<UInt8>) -> String{
        if self.uppercased {
            return digest.reduce("") { $0 + String(format:"%02X", $1) }
        }else{
            return digest.reduce("") { $0 + String(format:"%02x", $1) }
        }
    }

    private static func digestHashString(_ digest:Data) -> String{
        if self.uppercased {
            return digest.reduce("") { $0 + String(format:"%02X", $1) }
        }else{
            return digest.reduce("") { $0 + String(format:"%02x", $1) }
        }
        //return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}


