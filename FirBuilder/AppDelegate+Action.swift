//
//  AppDelegate+Action.swift
//  FirBuilder
//
//  Created by kimi on 2024/10/9.
//

import Foundation




extension AppDelegate{
    
    //浏览器打开网页
    @IBAction func goGithubAction(_ sender: Any) {
        let str = "https://github.com/RANSAA/FirBuilder";
        guard let url = URL(string: str) else { return }
        // 使用NSWorkspace打开默认浏览器
        NSWorkspace.shared.open(url)
    }
}
