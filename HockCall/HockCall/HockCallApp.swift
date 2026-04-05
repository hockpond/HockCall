import SwiftData
import SwiftUI

@main
struct HockCallApp: App {
    private let modelContainer: ModelContainer

    init() {
        let isRunningTests =
            ProcessInfo.processInfo.arguments.contains("UITEST")
            || ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

        if isRunningTests {
            UIView.setAnimationsEnabled(false)
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: isRunningTests)

        do {
            modelContainer = try ModelContainer(for: User.self, configurations: configuration)
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}

#Preview {
    ContentView()
}
