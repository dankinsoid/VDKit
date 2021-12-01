//
//  File.swift
//  
//
//  Created by Данил Войдилов on 26.10.2021.
//

#if canImport(UIKit)
import UIKit

extension UILabel {
	public convenience init(_ text: String) {
		self.init(frame: .zero)
		self.text = text
	}
	
	public convenience init(_ text: NSAttributedString) {
		self.init(frame: .zero)
		self.attributedText = text
	}
}

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension UILabel {
	
	public convenience init<P: Publisher>(_ text: P) where P.Output == String, P.Failure == Never {
		self.init(frame: .zero)
		text.subscribe(
			AnySubscriber(
				receiveSubscription: {
					_ = $0.request(.unlimited)
				},
				receiveValue: {[weak self] in
					self?.text = $0
					return .unlimited
				},
				receiveCompletion: nil
			)
		)
	}
}
#endif
#endif
