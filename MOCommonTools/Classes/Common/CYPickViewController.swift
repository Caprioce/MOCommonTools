//
//  CYPickViewController.swift
//  cooperator
//
//  Created by 张驰 on 2018/12/21.
//  Copyright © 2018年 ChiYue. All rights reserved.
//

import UIKit

protocol CYPickViewDelegate: NSObjectProtocol {

    func didSelect(_ index: Int)

}

class CYPickViewController: UIViewController {

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
    /// 白底
    fileprivate lazy var whiteView: UIView = {
        let whiteView = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 245))
        whiteView.backgroundColor = UIColor.white
        return whiteView
    }()
    /// 取消按钮
    fileprivate lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 48))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.color(hexString: "B9B9B9"), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return cancelButton
    }()
    /// 确定按钮
    fileprivate lazy var sureButton: UIButton = {
        let sureButton = UIButton(frame: CGRect(x: kScreenWidth - 72, y: 0, width: 72, height: 48))
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(kCYMainColor, for: .normal)
        sureButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        return sureButton
    }()
    /// 分割线
    fileprivate lazy var line: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: 47, width: kScreenWidth, height: 1))
        line.backgroundColor = kCYLineColor
        return line
    }()
    /// 选择器
    lazy var pickView: UIPickerView = {
        let pickView = UIPickerView(frame: CGRect(x: 0, y: 48, width: kScreenWidth, height: whiteView.frame.height - 48))
        pickView.dataSource = self
        pickView.delegate = self
        pickView.showsSelectionIndicator = true
        return pickView
    }()
    /// 标题
    fileprivate var titleArr = [String]()
    /// 选中的行
    fileprivate var selectIndex = 0
    weak var delegate: CYPickViewDelegate?

    convenience init(_ titleArr: [String]) {
        self.init(nibName: nil, bundle: nil)
        self.titleArr = titleArr
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAnimation()
    }

}

//MARK:- NetWork
extension CYPickViewController {

    fileprivate func requestData() {

    }

}

//MARK:- UI
extension CYPickViewController {

    fileprivate func prepareUI() {
        view.addSubview(shadowView)
        view.addSubview(whiteView)
        whiteView.addSubview(cancelButton)
        whiteView.addSubview(sureButton)
        whiteView.addSubview(line)
        whiteView.addSubview(pickView)
    }

}

//MARK:- Action
extension CYPickViewController {

    @objc fileprivate func cancelAction() {
        dismissAction()
    }

    @objc func sureAction() {
        dismissAction()
        guard let _ = delegate else { return }
        delegate!.didSelect(selectIndex)
    }

}

//MARK:- Private Method
extension CYPickViewController {

    fileprivate func showAnimation() {
        UIView.animate(withDuration: animationTime, animations: {
            self.whiteView.frame = CGRect(x: 0, y: kScreenHeight - 245, width: kScreenWidth, height: 245)
        })
    }

    @objc func dismissAction() {
        UIView.animate(withDuration: animationTime, animations: {
            self.whiteView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 245)
        }) { (complete) in
            self.dismiss(animated: true, completion: nil)
        }
    }

}

//MARK:- UITableViewDelegate
extension CYPickViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titleArr.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 37))
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.color(hexString: "333333")
        label.textAlignment = .center
        label.text = titleArr[row]
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 37
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectIndex = row
    }

}
