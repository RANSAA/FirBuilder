//
//  NSView+EditableView.swift
//  FirBuilder
//
//  Created by kimi on 2025/8/19.
//

import Foundation


//MARK: - 鼠标事件处理，递归判断在点击区域是否包含可编辑输入框
extension NSView {
    /// 判断视图是否是可编辑的输入控件
    var isEditableView: Bool {
        return self is NSTextField ||
               self is NSTextView ||
               self is NSComboBox ||
               self is NSSearchField
    }
    
    /// 递归查找包含某点的可编辑视图
    func editableViewContains(point: NSPoint) -> Bool {
        // 转换坐标到当前视图坐标系
        let localPoint = self.convert(point, from: self.superview)
        // 检查当前视图
        if isEditableView && bounds.contains(localPoint) {
            return true
        }
        
        // 递归检查子视图
        for subview in subviews {
            if subview.editableViewContains(point: point) {
                return true
            }
        }
        return false
    }
}
