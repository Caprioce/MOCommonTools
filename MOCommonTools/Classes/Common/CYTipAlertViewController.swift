//
//  CYTipAlertViewController.swift
//  cooperator
//
//  Created by 张驰 on 2018/11/13.
//  Copyright © 2018年 ChiYue. All rights reserved.
//  通用的提示框

import UIKit
import Dispatch

enum TipStyle: Int {
    /// 选择框
    case alert
    /// 提示
    case tip
}

class CYTipAlertViewController: UIViewController {

    /// alert风格(默认是normal)
    var alertStyle: TipStyle = .alert
    /// 文字
    var tipText: String?
    /// 左按钮文字
    var leftText: String?
    /// 右按钮文字
    var rightText: String?
    /// 图片名称
    var iconName: String?
    /// 确定的点击Block
    var sureBlock: (()->Void)?
    /// Tip类型消息时的回调Block
    var completeBlock: (()->Void)?
    /// 背景框
    fileprivate lazy var whiteView: UIView = {
        let whiteView = UIView(frame: CGRect(x: 38.0.suitWidth, y: 204.0.suitHeight, width: kScreenWidth - 2 * 38.0.suitWidth, height: 147.0.suitHeight))
        let cooner = UIRectCorner(arrayLiteral: .topLeft, .topRight, .bottomLeft, .bottomRight)
        let path = UIBezierPath(roundedRect: whiteView.bounds, byRoundingCorners: cooner , cornerRadii: CGSize(width: 12, height: 12))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.frame = whiteView.bounds
        whiteView.layer.mask = mask
        whiteView.backgroundColor = UIColor.white
        return whiteView
    }()
    /// 阴影
    fileprivate lazy var shadowView: UIView = {
        let shadowView = UIView(frame: UIScreen.main.bounds)
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(hideAction))
        //        shadowView.addGestureRecognizer(tap)
        return shadowView
    }()
    /// 取消按钮
    fileprivate lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(frame: CGRect(x: 0, y: whiteView.frame.height - 40.0.suitHeight, width: whiteView.frame.width/2, height: 40.0.suitHeight))
        cancelButton.backgroundColor = UIColor.color(hexString: "C7C7C7")
        cancelButton.setTitle(leftText, for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return cancelButton
    }()
    /// 确定按钮
    fileprivate lazy var sureButton: UIButton = {
        let sureButton = UIButton(frame: CGRect(x: whiteView.frame.width/2, y: whiteView.frame.height - 40.0.suitHeight, width: whiteView.frame.width/2, height: 40.0.suitHeight))
        sureButton.setTitle(rightText, for: .normal)
        sureButton.setTitleColor(UIColor.white, for: .normal)
        sureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        return sureButton
    }()
    /// 文字Tips
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = UIColor.color(hexString: "3F3F3F")
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        configTipFont(titleLabel)
        return titleLabel
    }()
    /// 图标
    fileprivate lazy var iconView: UIImageView = {
        let iconView = UIImageView(image: UIImage(named: iconName ?? ""))
        return iconView
    }()

    deinit {
        print("\(self) deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }

    fileprivate func makeUI() {
        view.addSubview(shadowView)
        view.addSubview(whiteView)
        switch alertStyle {
        case .alert:
            normalUI()
        case .tip:
            tipUI()
        }
    }

}

//MARK:- Class Init
extension CYTipAlertViewController {

    /// 创建一个normal类型的(不带图标，取消和确定)
    static func createNormalAlertView(_ title: String?, _ sureText: String? = "确定") -> CYTipAlertViewController {
        return createAlertView(nil, title, "取消", sureText, .alert)
    }

    /// 创建一个normal单按钮类型的(不带图标，单按钮)
    static func createNormalSureAlertView(_ title: String?, _ sureText: String? = "确定") -> CYTipAlertViewController {
        return createAlertView(nil, title, nil, sureText, .alert)
    }

    /// 创建一个normal带图类型的(带图标，单按钮)
    static func createNormalIconSureAlertView(_ icon: String?,_ title: String?, _ sureText: String? = "确定") -> CYTipAlertViewController {
        return createAlertView(icon, title, nil, sureText, .alert)
    }

    /// 创建一个成功提醒框
    static func createTipSuccessAlertView(_ title: String,_ complete: @escaping (()->Void)) -> CYTipAlertViewController {
        return createTipAlertView("Tch_007_hook", title, complete)
    }

    /// 创建一个提醒框Tch_007_hook
    static func createTipAlertView(_ icon: String,_ title: String,_ complete: @escaping (()->Void)) -> CYTipAlertViewController {
        return createAlertView(icon, title, nil, nil , .tip, complete)
    }

    /// 如果只有一个按钮 ，left为nil ，right为那个按钮
    static func createAlertView(_ icon: String?, _ title: String?, _ cancelText: String?,_ sureText: String?,_ alertStyle: TipStyle,_ complete: (()->Void)? = nil) -> CYTipAlertViewController {
        let vc = CYTipAlertViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.alertStyle = alertStyle
        vc.iconName = icon
        vc.tipText = title
        vc.leftText = cancelText
        vc.rightText = sureText
        vc.completeBlock = complete
        return vc
    }

}

//MARK:- UI
extension CYTipAlertViewController {

    /// 默认模式的UI
    fileprivate func normalUI() {
        whiteView.layer.mask = nil
        whiteView.layer.cornerRadius = 12
        whiteView.layer.masksToBounds = true
        whiteView.addSubview(titleLabel)
        whiteView.addSubview(sureButton)
        /// 单按钮如果是
        if leftText == nil {
            sureButton.setBackgroundImage(UIImage(named: "Tch_007_longGreen"), for: .normal)
            sureButton.frame = CGRect(x: 0, y: whiteView.frame.height - 40.0.suitHeight, width: whiteView.frame.width, height: 40.0.suitHeight)
        } else /// 双按钮
        {
            sureButton.setBackgroundImage(UIImage(named: "Tch_007_shortGreen"), for: .normal)
            whiteView.addSubview(cancelButton)
        }
        if let _ = iconName {
            whiteView.addSubview(iconView)
            iconView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 42, height: 42))
                make.centerX.equalTo(whiteView)
                make.top.equalTo(22.0.suitHeight)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.top.equalTo(iconView.snp.bottom)
                make.bottom.equalTo(sureButton.snp.top)
            }
        } else {
            titleLabel.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 10, bottom: 40.0.suitHeight, right: 10))
            }
        }
    }

    fileprivate func tipUI() {
        whiteView.layer.mask = nil
        whiteView.layer.cornerRadius = 12
        whiteView.layer.masksToBounds = true
        whiteView.addSubview(iconView)
        whiteView.addSubview(titleLabel)
        whiteView.frame = CGRect(x: 38.0.suitWidth, y: kNavigationHeight + 154.0.suitHeight, width: kScreenWidth - 2 * 38.0.suitWidth, height: 114.0.suitHeight)
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 37, height: 37))
            make.centerX.equalTo(whiteView)
            make.top.equalTo(18.0.suitHeight)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(iconView.snp.bottom).offset(5)
            make.bottom.equalTo(-5)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.dismissAction()
        }
    }

}

//MARK:- BtnAction
extension CYTipAlertViewController {

    @objc fileprivate func hideAction() {
        dismiss(animated: true, completion: nil)
    }

    @objc fileprivate func cancelAction() {
        hideAction()
    }

    @objc fileprivate func sureAction() {
        hideAction()
        if let _ = sureBlock {
            sureBlock!()
        }
    }

}

//MARK:- Private Method
extension CYTipAlertViewController {

    /// 根据字数设置whiteView高度
    fileprivate func configTipFont(_ contentLabel: UILabel) {
        /* --- 根据行数来选择是否设置行间距 --- */
        var count = tipText?.components(separatedBy: "\n").count
        if count == 1 {
            contentLabel.text = tipText
        } else {
            let attributeTitle = NSMutableAttributedString(string: tipText ?? "")
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = 10
            paragraphStyle.alignment = .center
            attributeTitle.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributeTitle.length))
            contentLabel.attributedText = attributeTitle
        }

        /* --- 根据行数来自适应弹框的高度 --- */
        let consultCount = consultLineArrays(label: contentLabel)
        /// 如果没有自己加换行符并且多于1行
        if count == 1, consultCount > 1 {
            count = consultCount
        }
        /// 如果有图标
        if let _ = iconName {
            count = (count ?? 1) + 1
        }
        /// 设置高度
        if count == 1 {

        } else if count == 2 {
            whiteView.frame = CGRect(x: 38.0.suitWidth, y: kNavigationHeight + 124.0.suitHeight, width: kScreenWidth - 2 * 38.0.suitWidth, height: 159.0.suitHeight)
        } else if count ?? 0 >= 3 {
            let height = (171.0 + 26.0 * Double(count! - 3)).suitHeight
            whiteView.frame = CGRect(x: 38.0.suitWidth, y: kNavigationHeight + 124.0.suitHeight, width: kScreenWidth - 2 * 38.0.suitWidth, height: height)
        }
    }

    /// 计算文字行数
    fileprivate func consultLineArrays(label: UILabel) -> Int {
        let text = label.text
        let font = label.font

        let fontName: CFString = font!.fontName as CFString
        let myFont = CTFontCreateWithName(fontName, font?.pointSize ?? 0, nil)
        let attStr = NSMutableAttributedString(string: text ?? "")
        attStr.addAttribute(.font, value: myFont, range: NSMakeRange(0, text?.count ?? 0))
        let CFAttStr: CFAttributedString = attStr as CFAttributedString
        let frameSetter = CTFramesetterCreateWithAttributedString(CFAttStr)
        let path = CGMutablePath.init()
        path.addPath(CGPath.init(rect: CGRect(x: 0, y: 0, width: (kScreenWidth - 2 * 38.0.suitWidth - 20) , height: 1000), transform: nil))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let arr = CTFrameGetLines(frame) as NSArray
        return arr.count
    }

    /// 消失
    func dismissAction() {
        dismiss(animated: true) {
            guard let _ = self.completeBlock else {return}
            self.completeBlock!()
        }
    }

}
