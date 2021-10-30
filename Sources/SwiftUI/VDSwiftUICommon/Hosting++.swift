//
//  File.swift
//  
//
//  Created by Данил Войдилов on 13.05.2021.
//

import SwiftUI
import Combine

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension UIHostingController {
	public convenience init(@ViewBuilder _ builder: () -> Content) {
		self.init(rootView: builder())
	}
	
	public convenience init<P: Publisher>(update: P, _ view: @escaping () -> Content) where P.Output == Void, P.Failure == Never {
		self.init(rootView: view())
		update.subscribe(
			AnySubscriber(
				receiveSubscription: {
					$0.request(.unlimited)
				},
				receiveValue: {
					self.rootView = view()
					return .unlimited
				},
				receiveCompletion: nil
			)
		)
	}
	
	public convenience init<P: Publisher>(update: P, _ view: @escaping @autoclosure () -> Content) where P.Output == Void, P.Failure == Never {
		self.init(update: update, view)
	}
}
