//
//  Alerts.swift
//  UIKitExtensions
//
//  Created by Daniil on 10.08.2019.
//

#if canImport(UIKit)
import UIKit

extension UIViewController {
	
	public func actionSheet(title: String?, message: String?) -> AlertHandler {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		let handler = AlertHandler(alert: alert, from: self)
		return handler
	}
	
	public func alert(title: String?, message: String?) -> AlertHandler {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let handler = AlertHandler(alert: alert, from: self)
		return handler
	}
	
	public final class AlertHandler {
		private weak var vc: UIViewController?
		private let alert: UIAlertController
		
		fileprivate init(alert: UIAlertController, from vc: UIViewController) {
			self.alert = alert
			self.vc = vc
		}
		
		public func addButton(_ title: String?, style: UIAlertAction.Style = .default, action: (() -> ())?) -> AlertHandler {
			let alertAction = UIAlertAction(title: title, style: style) { _ in
				action?()
			}
			alert.addAction(alertAction)
			return self
		}
		
		public func present(completion: (() -> ())? = nil) {
			vc?.present(alert, animated: true, completion: completion)
		}
	}
}
#endif
