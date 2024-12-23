import Foundation
import AVFoundation
import UserNotifications

class WordManager: ObservableObject {
    @Published var words: [Word] = []
    private let wordsKey = "savedWords"
    
    init() {
        loadWords()
        requestNotificationPermission()
    }
    
    func loadWords() {
        if let data = UserDefaults.standard.data(forKey: wordsKey),
           let decodedWords = try? JSONDecoder().decode([Word].self, from: data) {
            words = decodedWords
        }
    }
    
    func saveWords() {
        if let encoded = try? JSONEncoder().encode(words) {
            UserDefaults.standard.set(encoded, forKey: wordsKey)
        }
    }
    
    func addWord(_ word: Word) {
        words.append(word)
        saveWords()
    }
    
    func speakWord(_ word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func markWordAsReviewed() {
        if !words.isEmpty {
            var word = words[currentIndex]
            word.markAsReviewed()
            words[currentIndex] = word
            saveWords()
        }
    }
    
    func scheduleReviewReminder() {
        let content = UNMutableNotificationContent()
        content.title = "单词复习提醒"
        content.body = "是时候复习单词了！"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "wordReview", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                self.scheduleReviewReminder()
            }
        }
    }
    
    func exportWords() -> String {
        let csvString = words.map { "\($0.english),\($0.chinese)" }.joined(separator: "\n")
        return "英文,中文\n" + csvString
    }
    
    func importWords(from csvString: String) {
        let lines = csvString.components(separatedBy: .newlines)
        for line in lines.dropFirst() { // 跳过标题行
            let components = line.components(separatedBy: ",")
            if components.count == 2 {
                let word = Word(english: components[0].trimmingCharacters(in: .whitespaces),
                              chinese: components[1].trimmingCharacters(in: .whitespaces))
                addWord(word)
            }
        }
    }
} 