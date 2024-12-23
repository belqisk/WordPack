import Foundation
import AVFoundation

class WordManager: ObservableObject {
    @Published var words: [Word] = []
    private let wordsKey = "savedWords"
    
    init() {
        loadWords()
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
} 