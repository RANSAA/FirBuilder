//
//  SmartTextView.swift
//  FirBuilder
//
//  Created by kimi on 2025/8/18.
//

import Foundation


/**
 1. 监听成为第一响应者和失去第一响应值
 2. 实现placeholder文字
 */
class SmartTextView: NSTextView {
    /** 成为第一响应时者回调*/
    var onBecomeFirstResponder: (() -> Void)?
    /** 解除第一响应者时回调*/
    var onResignFirstResponder: (() -> Void)?
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if success {
            onBecomeFirstResponder?()
            
            //
            didSelecteEditTextView()
        }
        return success
    }

    override func resignFirstResponder() -> Bool {
        let success = super.resignFirstResponder()
        if success {
            onResignFirstResponder?()
            
            //解除第一响应这是更新一下
            didDeselectEditTextView()
        }
        return success
    }
    
    
    
// MARK: - placeholder属性
    var placeholder: String = "请输入内容..." {
        didSet { needsDisplay = true }
    }
    var placeholderColor: NSColor = .placeholderTextColor {
        didSet { needsDisplay = true }
    }
    /**
     状态管理​：
     使用isShowingPlaceholder标志位明确跟踪状态
     只在必要时重绘视图
     */
    private var isShowingPlaceholder = false
    
    
    // MARK: - 初始化
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        //注意如果在becomeFirstResponder相关方法中实现了对输入框的选中，离去操作；就可以不实现这两个通知操作
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidBeginEditing),
            name: NSText.didBeginEditingNotification,
            object: self
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidEndEditing),
            name: NSText.didEndEditingNotification,
            object: self
        )
        
        //初始化时需要判断是否显示placeholder
        showPlaceholderIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    // MARK: - 绘制Placeholder
    /**
     正确的绘制方式​：
     使用draw(_:)方法绘制placeholder，而不是直接设置文本
     避免影响实际的文本内容
     */
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if isShowingPlaceholder && string.isEmpty {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor,
                .font: font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
            ]

            let rect = dirtyRect.insetBy(dx: 5, dy: 0)
            placeholder.draw(in: rect, withAttributes: attributes)
        }
    }
    
    // MARK: - 鼠标按下
    /**
     功能: 鼠标按下时处理文本框选中操作
     注意：如果在becomeFirstResponder中实现了didSelecteEditTextView()操作，那么就可以不处理鼠标事件了
     */
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        didSelecteEditTextView()
    }
    
    // MARK: - 通知处理
    @objc private func textDidBeginEditing(_ notification: Notification) {
        didSelecteEditTextView()
        print("开始编辑......")
    }
    
    @objc private func textDidEndEditing(_ notification: Notification) {
//        showPlaceholderIfNeeded()
        didDeselectEditTextView()
        print("编辑结束....")
    }
    
    // MARK: - 根据条件判断是否显示Placeholder
    private func showPlaceholderIfNeeded() {
        if string.isEmpty {
            isShowingPlaceholder = true
            needsDisplay = true
        }
    }
    
    //MARK: - 选中输入文本框处理
    private func didSelecteEditTextView(){
        if string.isEmpty && isShowingPlaceholder {
            isShowingPlaceholder = false
            string = ""
            needsDisplay = true
        }
    }
    
    //MARK: - 取消选中输入文本框处理
    private func didDeselectEditTextView(){
        showPlaceholderIfNeeded()
    }
    
}
