//
//  FileSource.swift
//  Checksum
//
//  Created by Ruben Nine on 10/5/18.
//  Copyright © 2018 9Labs. All rights reserved.
//

import Foundation

class FileSource: InstantiableSource {
    typealias Provider = URL

    // MARK: - Public Properties

    let provider: URL
    let size: FileSize

    // MARK: - Private Properties

    private var fd: UnsafeMutablePointer<FILE>!

    // MARK: - Lifecycle

    required init?(provider url: URL) {
        self.provider = url

        if let fd = fopen(url.path, "r") {
            self.fd = fd
        } else {
            return nil
        }

        let curpos = ftello(fd)
        fseeko(fd, 0, SEEK_END)
        size = FileSize(ftello(fd))
        fseeko(fd, curpos, SEEK_SET)
    }

    deinit {
        close()
    }

    // MARK: - Internal functions

    func seek(position: FileSize) -> Bool {
        guard position < size else { return false }
        
        return (fseeko(fd, off_t(position), SEEK_SET) == 0)
    }

    func tell() -> FileSize {
        return FileSize(ftello(fd))
    }

    func eof() -> Bool {
        return tell() == size
    }

    func read(amount: FileSize) -> Data? {
        var data = Data(count: Int(amount))

        data.count = data.withUnsafeMutableBytes {
            fread($0.baseAddress, 1, Int(amount), fd)
        }

        return data
    }

    func close() {
        fclose(fd)
    }
}
