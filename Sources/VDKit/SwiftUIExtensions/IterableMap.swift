//
//  File.swift
//  
//
//  Created by Данил Войдилов on 15.08.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension IterableView {
    
    public func iterableModifier<M: ViewModifier>(_ modifier: M) -> IterableMapView<Self, M> {
        IterableMapView(base: self, modifier: modifier)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct IterableMapView<Base: IterableView, Modifier: ViewModifier>: IterableView {
    public var base: Base
    public var modifier: Modifier
    public var count: Int { base.count }
    
    public var body: some View {
        base.modifier(modifier)
    }
    
    public func iterate<V: IterableViewVisitor>(with visitor: V, reversed: Bool) -> Bool {
        base.iterate(with: MapIterableViewVisitor(modifier: modifier, base: visitor), reversed: reversed)
    }
    
    public func subrange(at range: Range<Int>) -> some IterableView {
        IterableMapView<Base.Subview, Modifier>(base: base.subrange(at: range), modifier: modifier)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct MapIterableViewVisitor<Base: IterableViewVisitor, Modifier: ViewModifier>: IterableViewVisitor {
    var modifier: Modifier
    var base: Base
    
    func visit<V>(_ value: V) -> Bool where V : View {
        base.visit(value.modifier(modifier))
    }
}
