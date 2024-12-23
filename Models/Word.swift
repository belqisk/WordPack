import Foundation

struct Word: Codable, Identifiable {
    let id: UUID
    let english: String
    let chinese: String
    var learned: Bool
    var reviewCount: Int
    var lastReviewDate: Date?
    var correctCount: Int = 0
    var wrongCount: Int = 0
    
    init(english: String, chinese: String) {
        self.id = UUID()
        self.english = english
        self.chinese = chinese
        self.learned = false
        self.reviewCount = 0
        self.lastReviewDate = nil
        self.correctCount = 0
        self.wrongCount = 0
    }
    
    mutating func markAsCorrect() {
        correctCount += 1
        reviewCount += 1
        lastReviewDate = Date()
        if correctCount >= 3 {
            learned = true
        }
    }
    
    mutating func markAsWrong() {
        wrongCount += 1
        reviewCount += 1
        lastReviewDate = Date()
    }
}
