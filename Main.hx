import haxe.Json;
import sys.io.File;

class Main
{
    static var symbolAtlasShit:Map<String, String> = new Map();

    static public function main():Void
        {
            var animateFile:String = File.getContent('./animTest/Animation4.json');
            var theJSON = Json.parse(animateFile);


            var coolParsed:Parsed = cast theJSON;

            /** Is <String, String> for easy compatibility with
                when it's parsed as HaxeFlixel animations, where it will
                be the 4 digit "0000" or so, instead of "0" when converted
                to an Int*/

            // for (i in coolParsed.AN.TL.L[0].FR)
                // trace(i.E);

            // Most likely?
            var hasSymbolDictionary:Bool = Reflect.hasField(coolParsed, "SD");

            if (hasSymbolDictionary)
                symbolAtlasShit = parseSymbolDictionary(coolParsed);


            loopTimeline(coolParsed.AN.TL, coolParsed);

            
            trace(loopShit);


            // trace(symbolAtlasShit.toString());
            trace(hasSymbolDictionary);

            // for (i in coolParsed)
                // trace(i);

            // trace(coolParsed.AN.STI);
        }

    static var loopShit:Int = 0;

    static function loopTimeline(TL:Timeline, coolParsed:Parsed)
    {
        // var numSymbols:Int = 0;

        for (layer in TL.L)
        {
            for (frame in layer.FR)
            {
                for (element in frame.E)
                {
                    if (Reflect.hasField(element, "SI"))
                    {   
                        // trace("FRAME" + frame.I);
                        // trace('Cool symbol instance!');
                        // trace(element.SI.SN);

                        var nestedSymbol = symbolMap.get(element.SI.SN);
                        loopTimeline(nestedSymbol.TL, coolParsed);
                        // loopTimeline(nestedSymbol.TL, coolParsed);

                        // trace(nestedSymbol.TL);
                        if (symbolAtlasShit.exists(element.SI.SN))
                            {
                                // trace(symbolAtlasShit.get(element.SI.SN));
                            }
                            
                        
                    }
                    else
                    {
                        // trace('ATLAS SYMBOL INSTANCE!');
                        // trace(element.ASI.N);
                    }

                    loopShit++;
                }
            }
        }

        // trace(numSymbols);
    }

    static function findArray(symbolName:String, coolParse:Parsed):Animation
    {

        for (symbol in coolParse.SD.S)
        {
            if (symbol.SN == symbolName)
            {
                // trace("found symbol! " + symbol.SN);
                return symbol;
            }   
        }

        return null;
    }

    static var symbolMap:Map<String, Animation> = new Map();

    static function parseSymbolDictionary(coolParsed:Parsed):Map<String, String>
    {   
        var awesomeMap:Map<String, String> = new Map();
        for (symbol in coolParsed.SD.S)
            {
                
                symbolMap.set(symbol.SN, symbol);

                var symbolName = symbol.SN;
                for (layer in symbol.TL.L)
                {
                    for (frame in layer.FR)
                    {
                        for (element in frame.E)
                        {
                            if (Reflect.hasField(element, 'ASI'))
                            {
                                awesomeMap.set(symbolName, element.ASI.N);
                            } 
                        }
                    }
                }
            }

        return awesomeMap;
    }

}
// Run through the AN file, and get all the symbol names
// Run through dictionary and get symbol instances and their spritesheet data

typedef Parsed = {
    var MD:Metadata;
    var AN:Animation;
    var SD:SymbolDictionary; // Doesn't always have symbol dictionary!!
}

typedef Metadata = {
    
    /** Framerate */
    var FRT:Int;
}

/** Basically treated like one big symbol*/
typedef Animation = {
    /** symbolName */
    var SN:String;
    var TL:Timeline;
    /** IDK what STI stands for, Symbole Type Instance?
        Anyways, it is NOT used in SYMBOLS, only the main AN animation    
    */
    var STI:Dynamic;
}

/** DISCLAIMER, MAY NOT ACTUALLY BE CALLED
    SYMBOL TYPE ISNTANCE, IM JUST MAKING ASSUMPTION!!*/
typedef SymbolTypeInstance = {
    // var TL:Timeline;
    // var SN:String;
}

typedef SymbolDictionary = {

    var S:Array<Animation>;
}

typedef Timeline = {
    /** Layers */
    var L:Array<Layer>;
}

// Singular layer, not to be confused with LAYERS
typedef Layer = {
    var LN:String;
    /** Frames */
    var FR:Array<Frame>;
}

typedef Frame = {
    var I:Int;
    /** Duration, in frames*/
    var DU:Int;
    /** Elements*/
    var E:Array<Element>;
}

typedef Element = {
    var SI:SymbolInstance;
    var ASI:AtlasSymbolInstance;
}

/**
    Symbol instance, for SYMBOLS and refers to SYMBOLS    
*/
typedef SymbolInstance = {
    var SN:String;
    /** SymbolType (Graphic, Movieclip, Button)*/
    var ST:String;

    var TRP:TransformationPoint;
    var M3D:Array<Float>;
}

typedef AtlasSymbolInstance = {
    var N:String;
    var M3D:Array<Float>;
}



typedef TransformationPoint = {
    var x:Float;
    var y:Float;
}