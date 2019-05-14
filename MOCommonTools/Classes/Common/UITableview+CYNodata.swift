//
//  UITableview+CYNodata.swift
//  cooperator
//
//  Created by 张驰 on 2019/2/14.
//  Copyright © 2019年 ChiYue. All rights reserved.
//

import Foundation

fileprivate var UITableviewNodataKey: String = "UITableviewNodataKey"

extension UITableView {

    var noDataView: UIView? {
        set {
            objc_setAssociatedObject(self, &UITableviewNodataKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UITableviewNodataKey) as? UIView
        }
    }

    /// 资料库搜索处使用
    func showNoData(_ isShow: Bool) {
        if isShow {
            if noDataView == nil {
                noDataView = UIView(frame: CGRect(x: 0, y: 10, width: frame.size.width, height: frame.size.height - 10))
                noDataView?.backgroundColor = UIColor.white
                let tipLable = UILabel(frame: CGRect(x: 16, y: 14, width: frame.size.width - 32, height: 18))
                tipLable.textColor = UIColor(hue: 173/255, saturation: 173/255, brightness: 173/255, alpha: 1)
                tipLable.text = "没有符合搜索条件的资料"
                noDataView?.addSubview(tipLable)
            }
            addSubview(noDataView!)
        } else {
            noDataView?.removeFromSuperview()
        }

    }

    /// 资料库搜索处使用
    func showNoData(_ isShow: Bool, _ tipText: String) {
        if isShow {
            if noDataView == nil {
                noDataView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
                noDataView?.backgroundColor = UIColor.white
                let tipLable = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width - 32, height: 20))
                tipLable.font = UIFont.systemFont(ofSize: 18)
                tipLable.textColor = UIColor(hue: 157/255, saturation: 157/255, brightness: 157/255, alpha: 1)
                tipLable.text = tipText
                tipLable.textAlignment = .center
                tipLable.center = noDataView!.center
                noDataView?.addSubview(tipLable)
            }
            addSubview(noDataView!)
        } else {
            noDataView?.removeFromSuperview()
        }
    }

    /// 显示自定义位置的无数据提示
    func showNoData(_ isShow: Bool, _ tipText: String, _ rect: CGRect, _ backColor: UIColor = UIColor.white) {
        if isShow {
            if noDataView == nil {
                noDataView = UIView(frame: rect)
                noDataView?.backgroundColor = backColor
                let tipLable = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width - 32, height: 20))
                tipLable.font = UIFont.systemFont(ofSize: 18)
                tipLable.textColor = UIColor(hue: 157/255, saturation: 157/255, brightness: 157/255, alpha: 1)
                tipLable.text = tipText
                tipLable.textAlignment = .center
                tipLable.center.x = noDataView!.center.x
                tipLable.center.y = rect.height/2 - 10
                noDataView?.addSubview(tipLable)
            }
            addSubview(noDataView!)
        } else {
            noDataView?.removeFromSuperview()
        }
    }

}
