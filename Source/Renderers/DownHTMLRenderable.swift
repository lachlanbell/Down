//
//  DownHTMLRenderable.swift
//  Down
//
//  Created by Rob Phillips on 5/28/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation
import libcmark-gfm

public protocol DownHTMLRenderable: DownRenderable {
    /**
     Generates an HTML string from the `markdownString` property

     - parameter options: `DownOptions` to modify parsing or rendering

     - throws: `DownErrors` depending on the scenario

     - returns: HTML string
     */
    
    func toHTML(_ options: DownOptions) throws -> String
}

public extension DownHTMLRenderable {
    /**
     Generates an HTML string from the `markdownString` property

     - parameter options: `DownOptions` to modify parsing or rendering, defaulting to `.Default`

     - throws: `DownErrors` depending on the scenario

     - returns: HTML string
     */
    
    public func toHTML(_ options: DownOptions = .Default) throws -> String {
        return try markdownString.toHTML(options)
    }
}

public struct DownHTMLRenderer {
    /**
     Generates an HTML string from the given abstract syntax tree

     **Note:** caller is responsible for calling `cmark_node_free(ast)` after this returns

     - parameter options: `DownOptions` to modify parsing or rendering, defaulting to `.Default`

     - throws: `ASTRenderingError` if the AST could not be converted

     - returns: HTML string
     */
    
    public static func astToHTML(_ ast: UnsafeMutablePointer<cmark_node>, options: DownOptions = .Default) throws -> String {
        guard let cHTMLString = cmark_render_html(ast, options.rawValue) else {
            throw DownErrors.astRenderingError
        }
        defer { free(cHTMLString) }
        
        guard let htmlString = String(cString: cHTMLString, encoding: String.Encoding.utf8) else {
            throw DownErrors.astRenderingError
        }

        return htmlString
    }
}
