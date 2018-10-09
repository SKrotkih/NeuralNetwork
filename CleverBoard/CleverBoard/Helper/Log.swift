//
//  Log.swift
//  eMia
//

import Foundation

func Log(message: String = "", _ path: String = #file, _ function: String = #function) {
   let file = path.components(separatedBy: "/").last!.components(separatedBy: ".").first! // Sorry
   NSLog("\(file).\(function): \(message)")
}

