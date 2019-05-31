//
//  PaddingString.swift
//  Concetration
//
//  Created by Darina on 30/05/2019.
//  Copyright © 2019 asu. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection where Self: StringProtocol {
    func paddingToLeft(upTo length: Int, using element: Element = " ") -> SubSequence {
        return repeatElement(element, count: Swift.max(0, length-count)) + suffix(Swift.max(count, count - length))
    }
}
