import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var editingItem: MortarJob?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        Button {
                            editingItem = item
                        } label: {
                            row(for: item)
                        }
                        .accessibilityIdentifier("row_\(item.id.uuidString)")
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Mortarline")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { showingSettings = true } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EditSheet(item: nil) { newItem in
                    if !store.add(newItem) {
                        showingPaywall = true
                    }
                }
            }
            .sheet(item: $editingItem) { item in
                EditSheet(item: item) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
        .tint(Theme.accent)
    }

    @ViewBuilder
    private func row(for item: MortarJob) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.location)
                .font(Theme.headlineFont)
                .foregroundStyle(.white)
            Text(item.id.uuidString.prefix(8))
                .font(Theme.captionFont)
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding(.vertical, 4)
    }
}

private struct EditSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var draft: MortarJob
    var onSave: (MortarJob) -> Void
    @FocusState private var focused: Bool

    init(item: MortarJob?, onSave: @escaping (MortarJob) -> Void) {
        _draft = State(initialValue: item ?? MortarJob())
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Location", text: $draft.location)
                TextField("Mix type", text: $draft.mixType)
                DatePicker("Date", selection: $draft.date, displayedComponents: .date)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focused = false
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationTitle("Job")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("editCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                    .accessibilityIdentifier("editSaveButton")
                }
            }
        }
    }
}
