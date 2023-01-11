//
//  DataSource.swift
//  ChecksumTests
//
//  Created by Ruben Nine on 14/09/2019.
//  Copyright © 2019 9Labs. All rights reserved.
//

import Foundation

class DataSource: InstantiableSource {
    typealias Provider = Data

    // MARK: - Public Properties

    let provider: Data
    let size: FileSize

    // MARK: - Private Properties

    private var seekOffset: FileSize = 0

    // MARK: - Lifecycle

    required init?(provider data: Data) {
        self.provider = data
        self.size = FileSize(data.count)
    }

    // MARK: - Internal functions

    func seek(position: FileSize) -> Bool {
        guard position < size else { return false }

        self.seekOffset = position

        return true
    }

    func tell() -> FileSize {
        return seekOffset
    }

    func eof() -> Bool {
        return tell() == size
    }

    func read(amount: FileSize) -> Data? {
        let start = Int(truncatingIfNeeded: seekOffset)
        let end: Int = min(start.advanced(by: Int(amount)), provider.count)
        let dataChunk = provider.subdata(in: start ..< end)

        seekOffset += FileSize(dataChunk.count)

        return dataChunk
    }
}
