//
//  CYActionSheetViewController.swift
//  cooperator
//
//  Created by 张驰 on 2018/12/18.
//  Copyright © 2018年 ChiYue. All rights reserved.
//

import UIKit
import SnapKit

let kScreenHeight = UIScreen.main.bounds.height
let kScreenWidth  = UIScreen.main.bounds.width
let kCYMainColor  = UIColor.color(hexString: "19A89F")
let kCYLineColor  = UIColor.color(hexString: "f6f6f6")
let kNavigationHeight = CGFloat(kScreenHeight > 736.0 ? 88.0 : 64.0)
let kStatusHeight = UIApplication.shared.statusBarFrame.height

class CYActionSheetViewController: UIViewController {

    /// 动画时间
    fileprivate let animationTime = 0.2
    /// 阴影
    fileprivate lazy var shadowView: UIView = {
        let shadowView = UIView(frame: UIScreen.main.bounds)
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        shadowView.addGestureRecognizer(tap)
        return shadowView
    }()
    /// 列表
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: CGFloat(63 * titleArr.count + 58)), style: .grouped)
        tableView.backgroundColor = UIColor(hue: 248/255, saturation: 248/255, brightness: 248/255, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 63
        tableView.register(CYActionSheetCell.self, forCellReuseIdentifier: "CYActionSheetCell")
        tableView.register(CYActionSheetFooterView.self, forHeaderFooterViewReuseIdentifier: "CYActionSheetFooterView")
        tableView.isScrollEnabled = false
        return tableView
    }()
    /// 所有选项
    var titleArr: [String] = [String]()
    /// 点击回调
    var clickBlock: ((Int) -> Void)?
    /// 选中的行数
    var selectIndex: Int?

    convenience init(titleArr: [String]) {
        self.init(titleArr: titleArr, selectIndex: nil)
    }

    convenience init(titleArr: [String], selectIndex: Int?) {
        self.init()
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
        self.titleArr = titleArr
        self.selectIndex = selectIndex
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(shadowView)
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAnimation()
    }

}

//MARK:- Private Method
extension CYActionSheetViewController {

    /// 显示的动画
    fileprivate func showAnimation() {
        UIView.animate(withDuration: animationTime) {
            self.tableView.frame = CGRect(x: 0, y: kScreenHeight - CGFloat(63 * self.titleArr.count + 58), width: kScreenWidth, height: CGFloat(63 * self.titleArr.count + 58))
        }
    }

    /// 消失的动画
    @objc fileprivate func dismissAction() {
        UIView.animate(withDuration: animationTime, animations: {
            self.tableView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: CGFloat(63 * self.titleArr.count + 58))
        }) { (result) in
            self.dismiss(animated: true, completion: nil)
        }
    }

    /// 消失的动画
    fileprivate func dismissAnimation(_ complete: (()->Void)?) {
        UIView.animate(withDuration: animationTime, animations: {
            self.tableView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: CGFloat(63 * self.titleArr.count + 58))
        }) { (result) in
            self.dismiss(animated: true, completion: complete)
        }
    }

}

//MARK:- UITableViewDelegate
extension CYActionSheetViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CYActionSheetFooterView") as! CYActionSheetFooterView
        view.cancelBlock = { [weak self] in
            guard let `self` = self else { return }
            self.dismissAction()
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 58
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CYActionSheetCell") as! CYActionSheetCell
        cell.config(content: titleArr[indexPath.row], isChoosen: (selectIndex == indexPath.row ? true:false))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissAnimation { [weak self] in
            if let _ = self?.clickBlock {
                self?.clickBlock!(indexPath.row)
            }
        }
    }

}


class CYActionSheetCell: UITableViewCell {

    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = UIColor.color(hexString: "808080")
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    fileprivate lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = kCYLineColor
        return line
    }()
    var content: String? {
        didSet {
            nameLabel.text = content
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        makeUI()
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func makeUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(line)
    }

    fileprivate func setUpUI() {
        nameLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }

    func config(content: String, isChoosen: Bool) {
        nameLabel.text = content
        if isChoosen {
            nameLabel.textColor = kCYMainColor
        } else {
            nameLabel.textColor = UIColor.color(hexString: "808080")
        }
    }

}

class CYActionSheetFooterView: UITableViewHeaderFooterView {

    fileprivate lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.color(hexString: "B8B8B8"), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return cancelButton
    }()
    var cancelBlock: (()->Void)?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func cancelAction() {
        guard let _ = cancelBlock else { return }
        cancelBlock!()
    }

}
