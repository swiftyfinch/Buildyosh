//
//  HardwareCollector.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 01.11.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Hardware {
    let model: String? // MacBook Pro
    let year: String? // Can be `middle XXXX`
    let processorName: String? // Dual-Core Intel Core i7
    let processorSpeed: String? // 2,5 GHz
    let memory: String? // 16 GB
}

final class HardwareCollector {
    func collect() -> Hardware {
        let systemProfileInfo = SystemProfile().collect()
        // "2,5 GHz Dual-Core Intel Core i7 Something else"
        return Hardware(model: systemProfileInfo?.model,
                        year: collectYear(),
                        processorName: systemProfileInfo?.processorName,
                        processorSpeed: systemProfileInfo?.processorSpeed,
                        memory: systemProfileInfo?.memory)
    }

    private func collectYear() -> String? {
        guard
            let modelName = SystemInfo().modelName
        else { return nil }

        let components = modelName.components(separatedBy: ["(", ")", ","])
        let rawYear = components.first { $0.regExp(#".*\d{4}.*"#) != nil }
        return rawYear?.trimmingCharacters(in: .whitespaces)
    }
}

extension String {
    func regExp(_ pattern: String, groups: [Int]? = nil) -> String? {
        guard let regExp = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(location: 0, length: utf16.count)
        let result = regExp.firstMatch(in: self, options: [], range: range)
        if let groups = groups {
            return groups.reduce(into: nil) { string, group in
                guard let part = result.flatMap({
                    Range($0.range(at: group), in: self)
                        .map { String(self[$0]) }
                }) else { return }

                if string == nil { string = part }
                else { string?.append(part) }
            }
        }
        return result.flatMap {
            Range($0.range, in: self)
                .map { String(self[$0]) }
        }
    }
}

// MARK: - SystemProfile

struct SystemProfile {
    struct Info {
        let model: String
        let processorName: String
        let processorSpeed: String
        let memory: String
    }

    func collect() -> Info? {
        let process = Process()
        let pipe = Pipe()
        process.launchPath = "/usr/sbin/system_profiler"
        process.arguments = ["SPHardwareDataType"]
        process.standardOutput = pipe
        process.launch()
        let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
        process.terminate()

        guard let output = String(data: outputData, encoding: .utf8) else { return nil }
        return parseOutput(output)
    }

    private func parseOutput(_ output: String) -> Info? {
        let components = output.components(separatedBy: "\n")
        guard
            let model = components.firstMap({ $0.regExp(#".*Model Name:\s(.*)"#, groups: [1]) }),
            let processorName = components.firstMap({ $0.regExp(#".*Processor Name:\s(.*)"#, groups: [1]) }),
            let processorSpeed = components.firstMap({ $0.regExp(#".*Processor Speed:\s(.*)"#, groups: [1]) }),
            let memory = components.firstMap({ $0.regExp(#".*Memory:\s(.*)"#, groups: [1]) })
        else { return nil }
        return Info(model: model.trimmingCharacters(in: .whitespaces),
                    processorName: processorName.trimmingCharacters(in: .whitespaces),
                    processorSpeed: processorSpeed.trimmingCharacters(in: .whitespaces),
                    memory: memory.trimmingCharacters(in: .whitespaces))
    }
}

extension Array {
    func firstMap<U>(_ transform: (Element) throws -> U?) rethrows -> U? {
        let f = try first(where: { try transform($0) != nil })
        return try f.flatMap(transform)
    }
}

// MARK: - SystemInfo

struct SystemInfo {
    var modelName: String? {
        guard let serial = serialNumber,
            let plist = try? PropertyList().load(from: .init(fileURLWithPath: plistPath)),
            let regionCode = Locale.current.regionCode,
            let names = plist["CPU Names"] as? [String: String],
            !names.isEmpty
        else {
            return nil
        }

        for language in Locale.preferredLanguages {
            let key = "\(serial.suffix(4))-\(language)_\(regionCode)"
            if let entry = names[key] { return entry }
        }
        return nil
    }

    private let plistPath = "\(NSHomeDirectory())/Library/Preferences/com.apple.SystemProfiler.plist"
    private var serialNumber: String? {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        return IORegistryEntryCreateCFProperty(service,
                                               "IOPlatformSerialNumber" as CFString,
                                               kCFAllocatorDefault,
                                               0).takeUnretainedValue() as? String
    }
}

struct PropertyList {
    func load(from url: URL) throws -> [String: Any]? {
        guard let plist = FileManager.default.contents(atPath: url.path) else { return nil }
        var format = PropertyListSerialization.PropertyListFormat.xml
        return try PropertyListSerialization.propertyList(from: plist,
                                                          options: .mutableContainersAndLeaves,
                                                          format: &format) as? [String: Any]
    }

    func save(_ plist: [String: Any], to url: URL) throws {
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try data.write(to: url, options: .atomic)
    }
}
