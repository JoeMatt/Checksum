//
//  Source.swift
//  Checksum
//
//  Created by Ruben Nine on 10/5/18.
//  Copyright © 2018 9Labs. All rights reserved.
//

import Foundation

public typealias FileSize = Int64

protocol Source {
    var size: FileSize { get }

    func seek(position: FileSize) -> Bool
    func tell() -> FileSize
    func read(amount: FileSize) -> Data?
    func eof() -> Bool
}

protocol InstantiableSource: Source {
    associatedtype Provider

    var provider: Provider { get }

    init?(provider: Provider)
}
