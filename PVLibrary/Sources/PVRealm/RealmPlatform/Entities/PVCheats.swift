//
//  PVCheats.swift
//  Provenance
//

import Foundation
import PVSupport
import RealmSwift
import PVLogging
import PVPrimitives

@objcMembers
public final class PVCheats: Object, CheatFile, LocalFileProvider {
    public dynamic var id = UUID().uuidString
    public dynamic var game: PVGame!
    public dynamic var core: PVCore!
    public dynamic var code: String!
    public dynamic var file: PVFile!
    public dynamic var date: Date = Date()
    public dynamic var lastOpened: Date?
    public dynamic var type: String!
    public dynamic var enabled: Bool = false

    public dynamic var createdWithCoreVersion: String!

    public convenience init(withGame game: PVGame, core: PVCore, code: String, type: String, enabled: Bool = false, file: PVFile ) {
        self.init()
        self.game = game
        self.code = code
        self.type = type
        self.enabled = enabled
        self.core = core
        self.file = file
        createdWithCoreVersion = core.projectVersion
    }

    public static func == (lhs: PVCheats, rhs: PVCheats) -> Bool {
        return lhs.code == rhs.code && lhs.type == rhs.type && lhs.enabled == rhs.enabled
    }

    public override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Conversions

public extension Cheats {
    init(with saveState: PVCheats) {
        let id = saveState.id
        let game = saveState.game.asDomain()
        let core = saveState.core.asDomain()
        let code = saveState.code!
        let type = saveState.type!
        let date = saveState.date
        let lastOpened = saveState.lastOpened
        let enabled = saveState.enabled
        let file = FileInfo(fileName: saveState.file.fileName, size: saveState.file.size, md5: saveState.file.md5, online: saveState.file.online, local: true)
        
        self.init(id: id, game: game, core: core, code: code, type: type, date: date, lastOpened: lastOpened, enabled: enabled, file: file)
    }
}

extension PVCheats: DomainConvertibleType {
    public typealias DomainType = Cheats

    public func asDomain() -> Cheats {
        return Cheats(with: self)
    }
}

extension Cheats: RealmRepresentable {
    public var uid: String {
        return code
    }

    public func asRealm() async -> PVCheats {
        return PVCheats.build { object in
            object.id = id
            let realm = try! Realm()
            if let rmGame = realm.object(ofType: PVGame.self, forPrimaryKey: game.md5) {
                object.game = rmGame
            } else {
                object.game = game.asRealm()
            }
            if let rmCore = realm.object(ofType: PVCore.self, forPrimaryKey: core.identifier) {
                object.core = rmCore
            } else {
                object.core = core.asRealm()
            }
            object.date = date
            let path = game.file.fileName.saveStatePath.appendingPathComponent(file.fileName)
            object.file = PVFile(withURL: path)
            object.lastOpened = lastOpened
            object.code=code
            object.type=type
            object.enabled=false
        }
    }
}
