import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var email: String
    @Attribute(.unique) var username: String
    var passwordHash: String
    var createdAt: Date

    init(email: String, username: String, passwordHash: String, createdAt: Date = .now) {
        self.email = email
        self.username = username
        self.passwordHash = passwordHash
        self.createdAt = createdAt
    }
}
