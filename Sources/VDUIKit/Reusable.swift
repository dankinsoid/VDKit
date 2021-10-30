//
//  Reusable.swift
//  UIKitExtensions
//
//  Created by Daniil on 10.08.2019.
//
#if canImport(UIKit)
import UIKit

extension UITableView {
    
    fileprivate struct AssociatedKey {
        static var registeredCellIdsSet = "_registeredCellIdsSet"
        static var registeredHeaderIdsSet = "_registeredHeaderIdsSet"
    }
    
    fileprivate var _registeredCellIdsSet: [String: String] {
        get { return objc_getAssociatedObject(self, &AssociatedKey.registeredCellIdsSet) as? [String: String] ?? [:] }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.registeredCellIdsSet, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var _registeredHeaderIds: [String: String] {
        get { return objc_getAssociatedObject(self, &AssociatedKey.registeredHeaderIdsSet) as? [String: String] ?? [:] }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.registeredHeaderIdsSet, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func _findRegistered(cellType: UITableViewCell.Type) -> String? {
        let registeredCellClasses = (value(forKey: "_cellClassDict") as? [String: Any]) ?? [:]
        for (key, value) in registeredCellClasses {
            if value as? AnyClass == cellType {
                return key
            }
        }
        let registeredNibs = (value(forKey: "_nibMap") as? [String: UINib]) ?? [:]
        for (key, value) in registeredNibs {
            if !value.instantiate(withOwner: self, options: nil).filter({ type(of: $0) == cellType }).isEmpty {
                return key
            }
        }
        return nil
    }
    
    fileprivate func _findRegistered(headerType: UITableViewHeaderFooterView.Type) -> String? {
        let registeredCellClasses = (value(forKey: "_headerFooterClassDict") as? [String: Any]) ?? [:]
        for (key, value) in registeredCellClasses {
            if value as? AnyClass == headerType {
                return key
            }
        }
        let registeredNibs = (value(forKey: "_headerFooterNibMap") as? [String: UINib]) ?? [:]
        for (key, value) in registeredNibs {
            if !value.instantiate(withOwner: self, options: nil).filter({ type(of: $0) == headerType }).isEmpty {
                return key
            }
        }
        return nil
    }
    
    public func reusableCell(of cellClass: UITableViewCell.Type, for indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: cellClass)
        if let _id = _registeredCellIdsSet[id] {
            return dequeueReusableCell(withIdentifier: _id, for: indexPath)
        }
        if let _id = _findRegistered(cellType: cellClass) {
            _registeredCellIdsSet[id] = _id
            return dequeueReusableCell(withIdentifier: _id, for: indexPath)
        }
        register(cellClass, forCellReuseIdentifier: id)
        _registeredCellIdsSet[id] = id
        return dequeueReusableCell(withIdentifier: id, for: indexPath)
    }
    
    public func reusable<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return reusableCell(of: cellClass, for: indexPath) as! T
    }
    
    public func reusableHeaderFooterView(of type: UITableViewHeaderFooterView.Type) -> UITableViewHeaderFooterView {
        let id = String(describing: type)
        if let _id = _registeredHeaderIds[id] {
            return dequeueReusableHeaderFooterView(withIdentifier: _id)!
        }
        if let _id = _findRegistered(headerType: type) {
            _registeredHeaderIds[id] = _id
            return dequeueReusableHeaderFooterView(withIdentifier: _id)!
        }
        register(type, forHeaderFooterViewReuseIdentifier: id)
        _registeredHeaderIds[id] = id
        return dequeueReusableHeaderFooterView(withIdentifier: id)!
    }
    
    public func reusable<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        return reusableHeaderFooterView(of: type) as! T
    }
    
}

extension UICollectionView {
    
    public enum SupplementaryViewKind {
        case footer, header, custom(String)
        
        public var string: String {
            switch self {
            case .footer:   return UICollectionView.elementKindSectionFooter
            case .header:    return UICollectionView.elementKindSectionHeader
            case .custom(let value): return value
            }
        }
    }
    
    fileprivate struct AssociatedKey {
        static var registeredCellIdsSet = "_registeredCellIdsSet"
        static var registeredViewIds = "_registeredViewIdsSet"
        static var registeredViewKinds = "_registeredViewKinds"
    }
    
    fileprivate var _registeredCellIdsSet: [String: String] {
        get { return objc_getAssociatedObject(self, &AssociatedKey.registeredCellIdsSet) as? [String: String] ?? [:] }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.registeredCellIdsSet, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var _registeredViewIds: [String: String] {
        get { return objc_getAssociatedObject(self, &AssociatedKey.registeredViewIds) as? [String: String] ?? [:] }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.registeredViewIds, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var _registeredViewKinds: [String: String] {
        get { return objc_getAssociatedObject(self, &AssociatedKey.registeredViewKinds) as? [String: String] ?? [:] }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.registeredViewKinds, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func _findRegistered(cellType: UICollectionViewCell.Type) -> String? {
        let registeredCellClasses = (value(forKey: "_cellClassDict") as? [String: Any]) ?? [:]
        for (key, value) in registeredCellClasses {
            if value as? AnyClass == cellType {
                return key
            }
        }
        let registeredNibs = (value(forKey: "_cellNibDict") as? [String: UINib]) ?? [:]
        for (key, value) in registeredNibs {
            if !value.instantiate(withOwner: self, options: nil).filter({ type(of: $0) == cellType }).isEmpty {
                return key
            }
        }
        return nil
    }
    
    fileprivate func _findRegistered(viewType: UICollectionReusableView.Type) -> (id: String, kind: String)? {
        let kinds = (value(forKey: "_supplementaryViewRegisteredKinds") as? Set<String>) ?? []
        let registeredCellClasses = (value(forKey: "_supplementaryViewClassDict") as? [String: Any]) ?? [:]
        for (key, value) in registeredCellClasses {
            if value as? AnyClass == viewType {
                var array = key.components(separatedBy: "/")
                guard array.count > 1 else { continue }
                let kind = array.removeFirst()
                if kinds.contains(kind) {
                    return (array.joined(), kind)
                }
            }
        }
        let registeredNibs = (value(forKey: "_supplementaryViewNibDict") as? [String: UINib]) ?? [:]
        for (key, value) in registeredNibs {
            if !value.instantiate(withOwner: self, options: nil).filter({ type(of: $0) == viewType }).isEmpty {
                var array = key.components(separatedBy: "/")
                guard array.count > 1 else { continue }
                let kind = array.removeFirst()
                if kinds.contains(kind) {
                    return (array.joined(), kind)
                }
            }
        }
        return nil
    }
    
    public func reusableCell(of cellClass: UICollectionViewCell.Type, for indexPath: IndexPath) -> UICollectionViewCell {
        let id = String(describing: cellClass)
        if let _id = _registeredCellIdsSet[id] {
            return dequeueReusableCell(withReuseIdentifier: _id, for: indexPath)
        }
        if let _id = _findRegistered(cellType: cellClass) {
            _registeredCellIdsSet[id] = _id
            return dequeueReusableCell(withReuseIdentifier: _id, for: indexPath)
        }
        register(cellClass, forCellWithReuseIdentifier: id)
        _registeredCellIdsSet[id] = id
        return dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
    }
    
    public func reusable<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return reusableCell(of: cellClass, for: indexPath) as! T
    }
    
    public func reusableSupplementaryView(of viewClass: UICollectionReusableView.Type, for indexPath: IndexPath) -> UICollectionReusableView {
        let id = String(describing: viewClass)
        if let _id = _registeredViewIds[id], let kind = _registeredViewKinds[id] {
            dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: _id, for: indexPath)
        }
        if let (_id, kind) = _findRegistered(viewType: viewClass) {
            _registeredViewIds[id] = _id
            _registeredViewKinds[id] = kind
            dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: _id, for: indexPath)
        }
        let kind = "SupplementaryView"
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: id)
        _registeredViewIds[id] = id
        _registeredViewKinds[id] = kind
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
    }
    
    public func reusable<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
        return reusableSupplementaryView(of: viewClass, for: indexPath) as! T
    }
    
    public func register(_ viewClass: UICollectionReusableView.Type, forSupplementaryViewOfKind elementKind: SupplementaryViewKind, withReuseIdentifier identifier: String) {
        register(viewClass, forSupplementaryViewOfKind: elementKind.string, withReuseIdentifier: identifier)
    }
    
    public func dequeueReusableSupplementaryView(ofKind elementKind: SupplementaryViewKind, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: elementKind.string, withReuseIdentifier: identifier, for: indexPath)
    }
    
}
#endif
