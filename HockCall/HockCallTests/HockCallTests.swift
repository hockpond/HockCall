import Foundation
import SwiftData
import Testing
@testable import HockCall

struct HockCallTests {
    @Test
    @MainActor
    func userPersistsValues() throws {
        let context = try makeModelContext()
        let user = User(email: "user@example.com", username: "hockpond", passwordHash: "hashed-123456")

        context.insert(user)
        try context.save()

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { $0.email == "user@example.com" }
        )
        let users = try context.fetch(descriptor)

        #expect(users.count == 1)
        #expect(users.first?.email == "user@example.com")
        #expect(users.first?.username == "hockpond")
        #expect(users.first?.passwordHash == "hashed-123456")
        #expect(users.first?.passwordHash != "123456")
    }

    @Test
    @MainActor
    func userEmailUniquenessPreventsDuplicateRecords() throws {
        let context = try makeModelContext()

        context.insert(User(email: "duplicate@example.com", username: "first-user", passwordHash: "hash-1"))
        try context.save()

        context.insert(User(email: "duplicate@example.com", username: "second-user", passwordHash: "hash-2"))
        try? context.save()

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { $0.email == "duplicate@example.com" }
        )
        let users = try context.fetch(descriptor)

        #expect(users.count == 1)
    }

    @Test
    @MainActor
    func userUsernameUniquenessPreventsDuplicateRecords() throws {
        let context = try makeModelContext()

        context.insert(User(email: "first@example.com", username: "duplicate-user", passwordHash: "hash-1"))
        try context.save()

        context.insert(User(email: "second@example.com", username: "duplicate-user", passwordHash: "hash-2"))
        try? context.save()

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { $0.username == "duplicate-user" }
        )
        let users = try context.fetch(descriptor)

        #expect(users.count == 1)
    }

    @MainActor
    private func makeModelContext() throws -> ModelContext {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: configuration)
        return ModelContext(container)
    }
}
