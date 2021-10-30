//
//  XibView.swift
//  MusicImport
//
//  Created by crypto_user on 04.12.2019.
//  Copyright © 2019 Данил Войдилов. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public protocol XibViewProtocol: UIView {
    static var nibName: String { get }
    static var bundle: Bundle { get }
    var xibContentView: UIView? { get set }
    func loadXibAndAddContent()
}

extension XibViewProtocol {
    public static var nibName: String { String(describing: Self.self) }
    public static var bundle: Bundle { Bundle(for: Self.self) }
    
    public func loadXibAndAddContent() {
        let array = Self.bundle.loadNibNamed(Self.nibName, owner: self, options: nil)
        guard let view = xibContentView ?? (array?.first as? UIView), view.superview == nil else { return }
        if xibContentView == nil {
            xibContentView = view
        }
        addSubview(view)
        view.setEdgesToSuperview()
    }
}

public typealias XibView = XibUIView & XibViewProtocol

open class XibUIView: UIView {
    
    @IBOutlet public var xibContentView: UIView?
    
    override public required init(frame: CGRect) {
        super.init(frame: frame)
        afterInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        afterInit()
    }
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    open func afterInit() {
        (self as? XibViewProtocol)?.loadXibAndAddContent()
    }
}
#endif
