//
//  JSONDecoder.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Foundation
//import CleanJSON


extension JSONDecoder{
    static func test(){
//        let str = """
//        {"userInfos":[{"userName":"小名","age":18,"height":178.56,"sex":true},{"userName":"小方","age":18,"height":162.56,"sex":false}]}
//        """
//        let jsonData = str.data(using: .utf8)
//
//
////        let jsonDecoder = JSONDecoder()
//        let jsonDecoder = CleanJSONDecoder()
//        let modelObject = try? jsonDecoder.decode(UserList.self, from: jsonData!)
//
//        print("str:\(str)")
//        print("jsonData:\(jsonData)")
//        print("modelObject:\(modelObject)")
//        print("modelObject type:\(type(of: modelObject))")
//        print(modelObject?.userInfos[0].userName)
//
//       
    }
}


struct UserList: Codable {

    let userInfos: [UserInfo]

    struct UserInfo: Codable {

        let userName: String
        let age: Int
        let height: Float
        let sex: Bool
        let type: String
    }
}
