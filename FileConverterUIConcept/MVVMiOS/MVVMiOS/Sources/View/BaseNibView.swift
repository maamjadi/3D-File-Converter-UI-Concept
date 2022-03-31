//
//  BaseNibView.swift
//
//
//  Created by Amjadi on 2022. 01. 04..
//

import UIKit

open class BaseNibView: UIView {

    @IBOutlet public weak var view: UIView!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        loadNib(nibName: nibName())
        self.setupUI()
    }

    open func setupUI() {
        self.backgroundColor = UIColor.clear
    }

    func nibName() -> String { String(describing: type(of: self)) }

    @discardableResult
    func loadNib(nibName: String) -> UIView? {
        if let contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.layoutAttachAll(to: self)
            self.addSubview(contentView)
            return contentView
        }
        return nil
    }
}

