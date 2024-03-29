//
//  TestObj.swift
//  Swift_Test
//
//  Created by Shashank Sastri on 10/2/19.
//  Copyright © 2019 Rosty H. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

//horrible name, but this serves as the top layer for the json object
//loaded into memory, contains an array of symbols
struct SymbolData: Codable {
    let symbols: [Symbol]
}


// MARK: - Symbol
struct Symbol: Codable {
    let name: String
    let x, y: Int
    let imgPath: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case name, x, y, imgPath
        case id = "ID"
    }
}

struct Coords{
    let x, y: Int;
}

class Test
{

    var isTextual: Bool;
    var answerSymbol: String;
    var symbols: [Symbol];
    var answerSymbols: [Coords];
    
    
    init(isTextual:Bool, jsonName: String, answerSymbol: String)
    {
        self.isTextual = isTextual;
        self.answerSymbol = answerSymbol;
        self.answerSymbols = [];
        //data: try Data(contentsOf: url)
        
        
        let path = Bundle.main.path(forResource: jsonName, ofType: "json")!
        
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe);
        
        //debug - gives you the string of data read in
        //var rawData = String(decoding: jsonData!, as: UTF8.self);
        
        let symbolData = try? JSONDecoder().decode(SymbolData.self, from: jsonData!);
        
        symbols = symbolData!.symbols;
        
    }
    
    func draw(context:CGContext)
    {
        
        let paragraphStyle = NSMutableParagraphStyle();
        paragraphStyle.alignment = .center
        
        
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.boldSystemFont(ofSize: 20.0),
            .foregroundColor: UIColor.black
            
        ]
        
        if(isTextual)
        {
            /*use names of symbols instead of image files
              saves the annoyance of having to create a lot of seperate
              bitmap files for symbols might also be nice for debugging*/
            
            for symbol in symbols
            {
                let symText = symbol.name;
                let attributedString = NSAttributedString(string: symText, attributes: attributes)
                
                let bBoxWidth = 25;
                let bBoxHeight = 25;

                let stringRect = CGRect(x: symbol.x, y: symbol.y, width: bBoxWidth, height: bBoxHeight)
                attributedString.draw(in: stringRect)
                
                context.beginPath()
                context.stroke(stringRect)
                
                /*if(symText == answerSymbol)
                {
                    //don't waste time and just push an object with the symbol's
                    //coords
                    
                    //add 1/2w and 1/2h to x & y to get symbol's center point
                answerSymbols.append(Coords(x:symbol.x+(bBoxWidth/2),y:symbol.y+(bBoxHeight/2)));
                }*/
            }
            
        }
        else
        {
            
        }
    }
    
}
