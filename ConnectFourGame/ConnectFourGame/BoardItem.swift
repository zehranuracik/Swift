//
//  BoardItem.swift
//  ConnectFourGame
//
//  Created by Zehra Nur Açık on 4.12.2023.
//

import Foundation
import UIKit

enum Tile{
    case Red
    case Yellow
    case Empty
}

struct BoardItem
{
    var indexPath: IndexPath!
    var tile: Tile!
    
    func yellowTile() -> Bool
    {
        return tile == Tile.Yellow
    }
    
    func redTile() -> Bool
    {
        return tile == Tile.Red
    }
    
    func emptyTile() -> Bool
    {
        return tile == Tile.Empty
    }
    
    func tileColor() -> UIColor
    {
        if redTile()
        {
            return .red
        }
        if yellowTile()
        {
            return .systemYellow
        }
        
        return .white
    }
}
