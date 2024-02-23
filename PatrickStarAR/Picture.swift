//
//  Picture.swift
//  PatrickStarAR
//
//  Created by jinyong yun on 2/21/24.
//

import Foundation

enum Picture {
    case Patrick
    
    // 파일 이름
    var name: String {
        switch self {
        case .Patrick: return "Patrick"
        }
    }
    
    // 파일이 있는 위치
    var assetLocation: String {
        switch self {
        case .Patrick:
            return "art.scnassets/Patrick.scn"
        }
    }
}
