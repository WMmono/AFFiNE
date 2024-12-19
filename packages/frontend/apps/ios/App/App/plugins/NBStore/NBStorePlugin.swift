import Foundation
import Capacitor

@objc(NbStorePlugin)
public class NbStorePlugin: CAPPlugin, CAPBridgedPlugin {
  private var docStorage: DocStorage?

  public let identifier = "NbStorePlugin"
  public let jsName = "NbStoreDocStorage"
  public let pluginMethods: [CAPPluginMethod] = [
      CAPPluginMethod(name: "create", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "connect", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "close", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "isClosed", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "checkpoint", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "validate", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "setSpaceId", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "pushUpdate", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "getDocSnapshot", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "setDocSnapshot", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "getDocUpdates", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "markUpdatesMerged", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "deleteDoc", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "getDocClocks", returnType: CAPPluginReturnPromise),
      CAPPluginMethod(name: "getDocClock", returnType: CAPPluginReturnPromise),
  ]

  @objc func create(_ call: CAPPluginCall) {
    let path = call.getString("path") ?? "";
    self.docStorage = try? DocStorage.init(path: path);
  }

  @objc func connect(_ call: CAPPluginCall) async {
    try? await self.docStorage?.connect()
  }

  @objc func close(_ call: CAPPluginCall) async {
    try? await self.docStorage?.close()
  }

  @objc func isClosed(_ call: CAPPluginCall) {
    call.resolve(["isClosed": self.docStorage?.isClosed() ?? true])
  }

  @objc func checkpoint(_ call: CAPPluginCall) async {
    try? await self.docStorage?.checkpoint()
  }

  @objc func validate(_ call: CAPPluginCall) async {
    let validate = (try? await self.docStorage?.validate()) ?? false
    call.resolve(["isValidate": validate])
  }

  @objc func setSpaceId(_ call: CAPPluginCall) async {
    guard let docStorage = self.docStorage else {
        call.reject("DocStorage not created. Please call create(...) first.")
        return
    }
    let spaceId = call.getString("spaceId") ?? ""
    do {
        try await docStorage.setSpaceId(spaceId: spaceId)
        call.resolve()
    } catch {
        call.reject("Failed to set space id", nil, error)
    }
  }

  @objc func pushUpdate(_ call: CAPPluginCall) async {
    guard let docStorage = self.docStorage else {
        call.reject("DocStorage not created. Please call create(...) first.")
        return
    }
    let docId = call.getString("docId") ?? ""
    let data = call.getArray("data", UInt8.self) ?? []
    do {
      let timestamp = try await docStorage.pushUpdate(docId: docId, update: Data(data))
        call.resolve(["timestamp": timestamp.timeIntervalSince1970])
    } catch {
        call.reject("Failed to push update", nil, error)
    }
  }

  @objc func getDocSnapshot(_ call: CAPPluginCall) async {
    guard let docStorage = self.docStorage else {
        call.reject("DocStorage not created. Please call create(...) first.")
        return
    }
    let docId = call.getString("docId") ?? ""
    do {
        if let record = try await docStorage.getDocSnapshot(docId: docId) {
            call.resolve([
                "docId": record.docId,
                "data": record.data,
                "timestamp": record.timestamp.timeIntervalSince1970
            ])
        } else {
            call.resolve()
        }
    } catch {
        call.reject("Failed to get doc snapshot", nil, error)
    }
  }

  @objc func setDocSnapshot(_ call: CAPPluginCall) async {
    guard let docStorage = self.docStorage else {
        call.reject("DocStorage not created. Please call create(...) first.")
        return
    }
    let docId = call.getString("docId") ?? ""
    let data = call.getArray("data", UInt8.self) ?? []
    let timestamp = Date()
    do {
        let success = try await docStorage.setDocSnapshot(
            snapshot: DocRecord(docId: docId, data: Data(data), timestamp: timestamp)
        )
        call.resolve(["success": success])
    } catch {
        call.reject("Failed to set doc snapshot", nil, error)
    }
  }

  @objc func getDocUpdates(_ call: CAPPluginCall) async {
    guard let docStorage = self.docStorage else {
        call.reject("DocStorage not created. Please call create(...) first.")
        return
    }
    let docId = call.getString("docId") ?? ""
    do {
        let updates = try await docStorage.getDocUpdates(docId: docId)
        let mapped = updates.map { [
            "docId": $0.docId,
            "createdAt": $0.createdAt.timeIntervalSince1970,
            "data": $0.data
        ] }
        call.resolve(["updates": mapped])
    } catch {
        call.reject("Failed to get doc updates", nil, error)
    }
  }

  @objc func markUpdatesMerged(_ call: CAPPluginCall) async {
    guard let docStorage = self.docStorage else {
        call.reject("DocStorage not created. Please call create(...) first.")
        return
    }
    let docId = call.getString("docId") ?? ""
    let times = call.getArray("timestamps", Double.self) ?? []
    let dateArray = times.map { Date(timeIntervalSince1970: $0) }
    do {
        let count = try await docStorage.markUpdatesMerged(docId: docId, updates: dateArray)
        call.resolve(["count": count])
    } catch {
        call.reject("Failed to mark updates merged", nil, error)
    }
  }

  @objc func deleteDoc(_ call: CAPPluginCall) async {
    guard let docStorage = self.docStorage else {
        call.reject("DocStorage not created. Please call create(...) first.")
        return
    }
    let docId = call.getString("docId") ?? ""
    do {
        try await docStorage.deleteDoc(docId: docId)
        call.resolve()
    } catch {
        call.reject("Failed to delete doc", nil, error)
    }
  }

  @objc func getDocClocks(_ call: CAPPluginCall) async {
    guard let docStorage = self.docStorage else {
        call.reject("DocStorage not created. Please call create(...) first.")
        return
    }
    do {
        let docClocks = try await docStorage.getDocClocks(after: nil)
        let mapped = docClocks.map { [
            "docId": $0.docId,
            "timestamp": $0.timestamp.timeIntervalSince1970
        ] }
        call.resolve(["clocks": mapped])
    } catch {
        call.reject("Failed to get doc clocks", nil, error)
    }
  }

  @objc func getDocClock(_ call: CAPPluginCall) async {
    guard let docStorage = self.docStorage else {
        call.reject("DocStorage not created. Please call create(...) first.")
        return
    }
    let docId = call.getString("docId") ?? ""
    do {
        if let docClock = try await docStorage.getDocClock(docId: docId) {
            call.resolve([
                "docId": docClock.docId,
                "timestamp": docClock.timestamp.timeIntervalSince1970
            ])
        } else {
            call.resolve()
        }
    } catch {
        call.reject("Failed to get doc clock", nil, error)
    }
  }
}
