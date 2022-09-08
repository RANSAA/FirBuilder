//
//  KakaJSON.swift
//  FirBuilder
//
//  Created by PC on 2022/9/2.
//

import Foundation
import KakaJSON


extension KakaJSON.Convertible {

    /**
     将当前model转换成另一种model
     */
    func kj_modelToModel<M: Convertible>(_ type: M.Type) -> M?    {
        if let model =  self.kj.JSONString().kj.model(M.self){
            return model
        }else{
            return nil
        }
    }
}


extension KakaJSON.ConvertibleKJ{

    /**
     将当前model转换成另一种model
     */
    func modelToModel<M: Convertible>(_ type: M.Type) -> M?{
        if let model = JSONString().kj.model(M.self) {
            return model
        }
        return nil
    }

}
