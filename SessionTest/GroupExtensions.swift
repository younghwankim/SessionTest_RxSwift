//
//  GroupExtensions.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//
// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Generics.html
// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-XID_543

import Foundation

/**
 Use `Customer` proxy as customization point for constrained protocol extensions.
 
 General pattern would be:
 
 // 1. Extend Customer protocol with constrain on Base
 // Read as: Customer Extension where Base is a SomeType
 extension Customer where Base: SomeType {
 // 2. Put any specific customer extension for SomeType here
 }
 
 With this approach we can have more specialized methods and properties using
 `Base` and not just specialized on common base type.
 
 */
public struct CustomerExtension<Base> {
    public let base: Base // Genric Type (Base)
    public init(_ base: Base) {
        self.base = base
    }
}

//  Associated Types
//
//  When defining a protocol, it’s sometimes useful to declare one or more associated types as part of the protocol’s definition.
//  An associated type gives a placeholder name to a type that is used as part of the protocol. The actual type to use for
//  that associated type isn’t specified until the protocol is adopted. Associated types are specified with the associatedtype keyword.
public protocol CustomerExtensionCompatible {
    associatedtype Compatible
    var customer: CustomerExtension<Compatible> { get set }
    static var customer: CustomerExtension<Compatible>.Type { get set }
}

//  Protocol Associated Type Declaration
//
//  Protocols declare associated types using the associatedtype keyword. An associated type provides an alias for a type that is used
//    as part of a protocol’s declaration. Associated types are similar to type parameters in generic parameter clauses, but they’re
//    associated with Self in the protocol in which they’re declared. In that context, Self refers to the eventual type that conforms
//    to the protocol. For more information and examples, see Associated Types.

// Generic Conforming
public extension CustomerExtensionCompatible {
    //Self refers to the eventual type that conforms to the protocol
    public var customer: CustomerExtension<Self> {
        get { return CustomerExtension(self) }
        set { // this enables using Extension to "mutate" base object
        }
    }
    public static var customer: CustomerExtension<Self>.Type {
        get { return CustomerExtension<Self>.self }
        set { // this enables using Extension to "mutate" base type
        }
    }
}

/**
 Use `Product` proxy as customization point for constrained protocol extensions.
 
 General pattern would be:
 
 // 1. Extend Product protocol with constrain on Base
 // Read as: Product Extension where Base is a SomeType
 extension Product where Base: SomeType {
 // 2. Put any specific product extension for SomeType here
 }
 
 With this approach we can have more specialized methods and properties using
 `Base` and not just specialized on common base type.
 
 
 */
public struct ProductExtension<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ProductExtensionCompatible {
    associatedtype Compatible
    var product: ProductExtension<Compatible> { get set }
    static var product: ProductExtension<Compatible>.Type { get set }
}

public extension ProductExtensionCompatible {
    public var product: ProductExtension<Self> {
        get { return ProductExtension(self) }
        set {// this enables using Extension to "mutate" base object
        }
    }
    public static var product: ProductExtension<Self>.Type {
        get { return ProductExtension<Self>.self }
        set {// this enables using Extension to "mutate" base type
        }
    }
}
