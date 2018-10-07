//
//  Storage.swift
//  CleverBoard
//

import Foundation

struct Storage {
    
    enum StorageError: Error {
        case fileIsNotExist
    }
    
    var exist: Bool {
        let fullPath = xmlURL.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fullPath) == false {
            if let localPath = Bundle.main.path(forResource: "layers", ofType: ".xml") {
                do {
                    try fileManager.copyItem(atPath: localPath, toPath: fullPath)
                } catch {
                    print("\nFailed to copy layers.xml to Documents folder with error:", error)
                }
            }
        }
        return fileManager.fileExists(atPath: fullPath)
    }
    
    lazy var layers: [Layer] = {
        var _layers = restore()
        if _layers.count == 0 {
            // Input -> Hidden layer
            let ihLayer = Layer(inputSize: Settings.inputSize, outputSize: Settings.hiddenSize)
            // Hidden -> Output layer
            let hoLayer = Layer(inputSize: Settings.hiddenSize, outputSize: Settings.outputSize)
            _layers.append(ihLayer)
            _layers.append(hoLayer)
        }
        return _layers
    }()

    private var xmlURL: URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent("layers.xml")
    }

    func save(_ layers: [Layer]) {
        let ls: [String: Any] = ["l1": layers[0].pack(), "l2": layers[1].pack()]
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: ls, format: .xml, options: 0)
            try plistData.write(to: xmlURL)
        } catch  {
            fatal()
        }
    }
    
    private func restore() -> [Layer] {
        var _layers: [Layer] = []
        do {
            let dict = try loadPropertyList()
            if let l1 = dict["l1"] as? [String: String], let oStr = l1["output"], let wStr = l1["weight"] {
                let output: [Float] = oStr.components(separatedBy: ",").map { item in
                    Float(item) ?? 0.0
                }
                let weight: [Float] = wStr.components(separatedBy: ",").map { item in
                    Float(item) ?? 0.0
                }
                let ihLayer = Layer(inputSize: Settings.inputSize, output: output, weights: weight)
                _layers.append(ihLayer)
            }
            if let l2 = dict["l2"] as? [String: String], let oStr = l2["output"], let wStr = l2["weight"] {
                let output: [Float] = oStr.components(separatedBy: ",").map { item in
                    Float(item) ?? 0.0
                }
                let weight: [Float] = wStr.components(separatedBy: ",").map { item in
                    Float(item) ?? 0.0
                }
                let hoLayer = Layer(inputSize: Settings.hiddenSize, output: output, weights: weight)
                _layers.append(hoLayer)
            }
        } catch(let error) {
            print("\(error)")
        }
        return _layers
    }

    private func loadPropertyList() throws -> [String: Any]
    {
        let data = try Data(contentsOf: xmlURL)
        guard let xml = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            throw StorageError.fileIsNotExist
        }
        return xml
    }
}
