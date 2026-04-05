import SwiftData
import SwiftUI

@main
struct HockCallApp: App {
    init() {
        if ProcessInfo.processInfo.arguments.contains("UITEST") {
            UIView.setAnimationsEnabled(false)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    ContentView()
}
