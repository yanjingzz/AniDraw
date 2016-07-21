//
//  Moves.swift
//  AniDraw
//
//  Created by Mike on 7/6/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation

class MovesStorage {
    
    static var AllMoves:[Int: [DanceMove]] {
        var dict = [Int: [DanceMove]]()
        for i in 1...5 {
            dict[i] = [DanceMove]()
        }
        for move in EthnicMoves.AllMoves {
            dict[move.level]!.append(move)
        }
        for move in GenericMoves.AllMoves {
            dict[move.level]!.append(move)
        }
        for move in JazzMoves.AllMoves {
            dict[move.level]!.append(move)
        }
        for move in BalletMoves.AllMoves {
            dict[move.level]!.append(move)
        }
        return dict
    }
    
    static let array:[DanceMove] = GenericMoves.AllMoves + EthnicMoves.AllMoves + JazzMoves.AllMoves + BalletMoves.AllMoves
}