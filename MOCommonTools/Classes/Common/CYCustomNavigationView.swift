//
//  CYCustomNavigationView.swift
//  cooperator
//
//  Created by 张驰 on 2019/1/15.
//  Copyright © 2019年 ChiYue. All rights reserved.
//

import UIKit

class CYCustomNavigationView: UIView {

    /// 背景
    fileprivate lazy var backView: UIView = {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationHeight))
        backView.drawColor()
        return backView
    }()
    /// 返回按钮
    fileprivate lazy var backBtn: UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "navi_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return backBtn
    }()
    /// 标题
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.color(hexString: "ffffff")
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    /// 右上角按钮
    fileprivate lazy var barButtonItem: UIButton = {
        let barButtonItem = UIButton()
        barButtonItem.setTitleColor(UIColor.white.withAlphaComponent(0.95), for: .normal)
        barButtonItem.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        barButtonItem.addTarget(self, action: #selector(itemClickAction(_:)), for: .touchUpInside)
        return barButtonItem
    }()
    /// 标题
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    /// barButtonItem的text
    var barItemTxt: String? {
        didSet {
            barButtonItem.setTitle(barItemTxt, for: .normal)
        }
    }
    /// barButtonItem的text
    var barItemImage: String? {
        didSet {
            guard let imgName = barItemImage else { return }
            barButtonItem.setImage(UIImage(named: imgName), for: .normal)
        }
    }
    /// 导航栏颜色
    var navColor: UIColor? {
        didSet {
            guard let color = navColor else { return }
            guard let sublayers = backView.layer.sublayers else { return }
            for item in sublayers {
                if item.isKind(of: CAGradientLayer.self) {
                    item.removeFromSuperlayer()
                }
            }
            backView.backgroundColor = color
        }
    }
    /// 是否可以编辑
    var canEdit = false {
        didSet {
            if canEdit {
                barButtonItem.setTitleColor(UIColor.white, for: .normal)
                barButtonItem.isEnabled = true
            } else {
                barButtonItem.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .normal)
                barButtonItem.isEnabled = false
            }
        }
    }
    /// 设置字体大小
    var fontSize: CGFloat? {
        didSet {
            guard let size = fontSize else { return }
            barButtonItem.titleLabel?.font = UIFont.systemFont(ofSize: size)
        }
    }

    /// back回调
    var backBlock: (()->Void)?
    /// rightBarButtonItem回调
    var rightBarButtonItemBlock: (()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func makeUI() {
        addSubview(backView)
        backView.addSubview(backBtn)
        backView.addSubview(titleLabel)
        backView.addSubview(barButtonItem)

        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(kStatusHeight + 3)
            make.size.equalTo(CGSize(width: 41, height: 41))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(backBtn)
        }
        barButtonItem.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(titleLabel)
        }
    }

}

//MARK:- Action
extension CYCustomNavigationView {

    @objc fileprivate func backAction() {
        guard let _ = backBlock else { return }
        backBlock!()
    }

    @objc fileprivate func itemClickAction(_ btn: UIButton) {
        guard let _ = rightBarButtonItemBlock else { return }
        rightBarButtonItemBlock!()
    }

}
