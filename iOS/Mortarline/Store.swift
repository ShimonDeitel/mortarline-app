import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [MortarJob] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Deliberately kept above the seed count so a fresh
    /// install never trips the paywall on first launch.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Mortarline", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("items.json")
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([MortarJob].self, from: data) else {
            items = [
        MortarJob(location: "Sample Location 1", mixType: "Sample Mix 1", date: Date().addingTimeInterval(-604800)),
        MortarJob(location: "Sample Location 2", mixType: "Sample Mix 2", date: Date().addingTimeInterval(-1209600)),
        MortarJob(location: "Sample Location 3", mixType: "Sample Mix 3", date: Date().addingTimeInterval(-1814400))
            ]
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    @discardableResult
    func add(_ item: MortarJob) -> Bool {
        guard canAddMore else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: MortarJob) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: MortarJob) {
        items.removeAll { $0.id == item.id }
        save()
    }
}
