//
//  Composite.swift
//  DesignPattern
//
//  Created by keyl on 2023/6/5.
//

import Foundation

protocol File {
    var name: String { get set }
    func open()
}

final class eBook: File {
    var name: String
    var author: String
    
    init(name: String, author: String) {
        self.name = name
        self.author = author
    }
    
    func open() {
        print("Opening \(name) by \(author) in eBooks...\n")
    }
}


final class Music: File {
    var name: String
    var artist: String
    
    init(name: String, artist: String) {
        self.name = name
        self.artist = artist
    }
    
    func open() {
        print("Playing \(name) by \(artist) in iTunes...\n")
    }
}

final class Folder: File {
    var name: String
    lazy var files: [File] = []
    
    init(name: String) {
        self.name = name
    }
    
    func addFile(file: File) {
        self.files.append(file)
    }
    
    func open() {
        print("Displaying the following files in \(name)...")
        for file in files {
            print(file.name)
        }
        print("\n")
    }
}

extension ViewController {
    
    func compositeExample() {
        let psychoKiller = Music(name: "Psycho Killer", artist: "The Talking Heads")
        let rebelRebel = Music(name: "Rebel Rebel", artist: "David Bowie")
            
        let justKids = eBook(name: "Just Kids", author: "Patti Smith")
        
        let document = Folder(name: "Documents")
        document.addFile(file: psychoKiller)
        document.addFile(file: rebelRebel)
        document.addFile(file: justKids)
        
        document.open()
    }
    
}
