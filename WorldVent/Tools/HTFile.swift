//
//  HTFile.swift
//  WorldVentTests
//
//  Created by mark bernstein on 4/23/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import Foundation


public struct HTFile  {

    public var path=""
    
    public init(path:String) {
        self.path=path
    }

    var filePath : String {
        let fileName = NSString(string: self.path).deletingPathExtension        
        
        let fpath=Bundle.main.path(forResource: fileName, ofType: "html", inDirectory: "Documentation")
        if let result=fpath {
            return result
        }
        return ""
    }
    
    public var allFiles: [String] {
        let fpath=Bundle.main.path(forResource: "Documentation", ofType: "", inDirectory: "")
        guard let f = fpath else {return []}
        var files=Array<String>()
        let enumerator=FileManager.default.enumerator(atPath: f)
        guard let e=enumerator else {return []}
        for f in e.enumerated() {
            let file=f.element as! String
            if (file.contains(".html")) {
                files.append(file)
            }
        }
        return files
    }
    
    public var url : URL {
        return URL(fileURLWithPath: self.filePath)
    }
    
    public var exists: Bool {
        let found=FileManager.default.fileExists(atPath: self.filePath)
        return found
    }

    public  var html : String {
        let data=FileManager.default.contents(atPath: self.filePath)
        var result=""
        if let theData=data{
            if let s=String(data:theData,encoding:String.Encoding.utf8){
                result=s
            }
        }
        return result
    }
    
    public func extractHref(tag:String)  ->String  {
        let pattern="href=\"(.*?)\""
        let tagger = try? NSRegularExpression(pattern:pattern,options:regexOptions)
        let nsrange=NSRange(tag.startIndex..<tag.endIndex,in: tag)
        var dest=""
        tagger?.enumerateMatches(in: tag, options: [], range: nsrange, using: { (result, flags, stop) in
            guard let r=result else {return }
            if (!(r.numberOfRanges==2)) {return}
            guard let range = Range(r.range(at: 1),in: tag) else {return}
            dest=String(tag[range])
        })
        return dest
    }
    
    public var stylesheets : [String] {
        var result=Array<String>()
        let pattern="<link rel=\"stylesheet\".*>"
        let tagger = try? NSRegularExpression(pattern:pattern,options:regexOptions)
        let html=self.html
        let nsrange=NSRange(html.startIndex..<html.endIndex,in: html)
        tagger?.enumerateMatches(in: html, options: [], range: nsrange, using: { (rr, flags, stop) in
            guard let r=rr else {return }
            guard let range = Range(r.range,in: html) else {return}
            let tag=html[range]
            let path=extractHref(tag: String(tag))
            result.append(path)
        })
        return result
    }
    
    public var searchText:String {
        /*
        let s=styledText;
        if let stext=s {return stext.string}
        */
        return html;
    }
    
    public var styledText:NSAttributedString? {
        let d=self.html.data(using:String.Encoding.utf8 )
        guard let data=d else{ return nil;}
        guard let ns=try? NSAttributedString(data: data, options:
            [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) else {return nil;}
        return ns;

    }

    
    public var links: [String] {
        var result=Array<String>()
        var destinations=Set<String>()
        let ns=self.styledText;
        guard let s=ns?.string else {return result}
        let nsrange=NSRange(s.startIndex..<s.endIndex,in: s)

        ns?.enumerateAttribute(NSAttributedString.Key.link, in: nsrange, options: []) { (value, range, stop) in
            if let url = value as? URL {
                let scheme=url.scheme
                if (scheme=="applewebdata" || scheme=="") { // ignore non-local files
                    destinations.insert(url.path)
                }
            }
        }
        result=Array(destinations)
        return result
    }

    private var regexOptions: NSRegularExpression.Options {
        return [NSRegularExpression.Options.caseInsensitive,NSRegularExpression.Options.useUnicodeWordBoundaries]
    }
    
    public var viewport: String {
        var tag=""
        let pattern="<meta.*name=\"viewport\""
        let tagger = try? NSRegularExpression(pattern:pattern,options:regexOptions)
        let html=self.html
        let nsrange=NSRange(html.startIndex..<html.endIndex,in: html)
        tagger?.enumerateMatches(in: html, options: [], range: nsrange, using: { (result, flags, stop) in
               guard let r=result else {return }
               guard let range = Range(r.range,in: html) else {return}
               tag=String(html[range])
           })
        return tag
    }
    
    public var headings:[String]{
        var headings=Array<String>()
        let pattern="<h1.*?>(.*)</h1"
        let tagger = try? NSRegularExpression(pattern:pattern,options:regexOptions)
        let html=self.html
        let nsrange=NSRange(html.startIndex..<html.endIndex,in: html)
        tagger?.enumerateMatches(in: html, options: [], range: nsrange, using: { (result, flags, stop) in
            guard let r=result else {return }
            if (r.numberOfRanges<2) {return;}
            guard let range = Range(r.range(at:1),in: html) else {return}
            let tag=String(html[range])
            headings.append(tag)
            })
        return headings
    }
    
 
    
}

