import Foundation

struct Word: Codable, Identifiable {
    let id: UUID
    let english: String
    let chinese: String
    var learned: Bool
    var reviewCount: Int
    var lastReviewDate: Date?
    
    init(english: String, chinese: String) {
        self.id = UUID()
        self.english = english
        self.chinese = chinese
        self.learned = false
        self.reviewCount = 0
        self.lastReviewDate = nil
    }
    
    mutating func markAsReviewed() {
        reviewCount += 1
        lastReviewDate = Date()
        if reviewCount >= 3 {
            learned = true
        }
    }
}
