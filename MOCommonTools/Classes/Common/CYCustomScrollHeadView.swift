//
//  CYCustomScrollHeadView.swift
//  cooperator
//
//  Created by 张驰 on 2018/12/17.
//  Copyright © 2018年 ChiYue. All rights reserved.
//

import UIKit

class CYCustomScrollHeadView: UIView {

    fileprivate lazy var leftButton: UIButton = {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width/2, height: frame.height))
        leftButton.setTitleColor(UIColor.color(hexString: "B5B5B5"), for: .normal)
        leftButton.setTitleColor(kCYMainColor, for: .selected)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftButton.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        leftButton.isSelected = true
        leftButton.tag = 1
        return leftButton
    }()
    fileprivate lazy var rightButton: UIButton = {
        let rightButton = UIButton(frame: CGRect(x: frame.width/2, y: 0, width: frame.width/2, height: frame.height))
        rightButton.setTitleColor(UIColor.color(hexString: "B5B5B5"), for: .normal)
        rightButton.setTitleColor(kCYMainColor, for: .selected)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightButton.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        rightButton.tag = 2
        return rightButton
    }()
    fileprivate lazy var line: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: frame.height - 1, width: frame.width/2, height: 1))
        line.backgroundColor = kCYMainColor
        return line
    }()
    fileprivate lazy var selectBtn = leftButton
    /// 切换回调
    var clickBlock: ((Int)->Void)?
    /// line的X
    var lineX: CGFloat = 0 {
        didSet {
            line.frame = CGRect(x: lineX, y: line.frame.origin.y, width: line.frame.width, height: line.frame.height)
        }
    }
    var selectIndex: Int = 0 {
        didSet {
            selectBtn.isSelected = false
            if selectIndex == 0 {
                selectBtn = leftButton
            } else {
                selectBtn = rightButton
            }
            selectBtn.isSelected = true
        }
    }
    /// 左边按钮标题
    var leftTitle: String = "" {
        didSet {
            leftButton.setTitle(leftTitle, for: .normal)
        }
    }
    /// 右边按钮标题
    var rightTitle: String = "" {
        didSet {
            rightButton.setTitle(rightTitle, for: .normal)
        }
    }

    convenience init(frame: CGRect, leftTitle: String, rightTitle: String) {
        self.init(frame: frame)
        config(leftTitle, rightTitle)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func makeUI() {
        backgroundColor = UIColor.white
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(line)
    }

    @objc fileprivate func clickAction(_ btn: UIButton) {
        //如果点击的是选中的按钮 不做变动
        if btn == selectBtn {
            return
        }
        selectBtn.isSelected = false
        selectBtn = btn
        selectBtn.isSelected = true
        guard let _ = clickBlock else { return }
        clickBlock!(btn.tag - 1)
    }

    func config(_ leftTitle: String, _ rightTitle: String) {
        leftButton.setTitle(leftTitle, for: .normal)
        rightButton.setTitle(rightTitle, for: .normal)
    }

}

//MARK:- Private Method
extension CYCustomScrollHeadView {

    /// 主动切换 0：主动点击左边 1：主动点击右边
    func activeClickAction(type: Int) {
        if type == 0 {
            leftButton.sendActions(for: .touchUpInside)
        } else if type == 1 {
            rightButton.sendActions(for: .touchUpInside)
        }
    }

}

