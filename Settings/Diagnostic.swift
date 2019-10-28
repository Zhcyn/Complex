//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import Foundation
extension Bundle {
    var name: String {
        info(for: "CFBundleDisplayName") ?? info(for: "CFBundleName") ?? ""
    }
    var version: String {
        info(for: "CFBundleShortVersionString") ?? ""
    }
    var build: String {
        info(for: "CFBundleVersion") ?? ""
    }
    var formattedVersion: String {
        let format = NSLocalizedString("bundle.formattedVersion", value: "%@ %@ (%@)", comment: "<App Name> <Version Number> (<Build Number>)")
        return String.localizedStringWithFormat(format, name, version, build)
    }
    private func info<T>(for key: String) -> T? {
        (localizedInfoDictionary?[key] as? T)
            ?? (infoDictionary?[key] as? T)
    }
}
import UIKit
extension UIDevice {
    func formattedDiagnostics(forBundle bundle: Bundle = .main) -> String {
        "\(bundle.formattedVersion)\n\(systemName) \(systemVersion)\n\(type ?? model)"
    }
}
extension UIDevice {
    var type: String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0)
            }
        }
    }
}
