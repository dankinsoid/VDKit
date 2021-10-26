//
//  LayoutableView.swift
//  TodoList
//
//  Created by Данил Войдилов on 08.07.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

import UIKit

open class LayoutableView: UIView {
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		afterInit()
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		afterInit()
	}
	
	public convenience init() {
		self.init(frame: .zero)
	}
	
	open func afterInit() {
		add(layout)
	}
	
	open func layout() -> [SubviewProtocol] {
		[]
	}
}

open class LayoutableViewController: UIViewController {
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		view.add(layout)
	}
	
	open func layout() -> [SubviewProtocol] {
		[]
	}
}
