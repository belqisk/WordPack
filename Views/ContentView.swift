import SwiftUI

struct ContentView: View {
    @StateObject private var wordManager = WordManager()
    @State private var currentIndex = 0
    @State private var showingChinese = false
    @State private var showingAddWord = false
    @State private var learningMode: LearningMode = .all
    
    enum LearningMode {
        case all, notLearned, needReview
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if !wordManager.words.isEmpty {
                    Text(wordManager.words[currentIndex].english)
                        .font(.largeTitle)
                        .padding()
                        .onTapGesture {
                            wordManager.speakWord(wordManager.words[currentIndex].english)
                        }
                    
                    if showingChinese {
                        Text(wordManager.words[currentIndex].chinese)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Button("显示翻译") {
                            showingChinese.toggle()
                        }
                        .padding()
                        
                        Button("下一个") {
                            if !wordManager.words.isEmpty {
                                wordManager.markWordAsReviewed()
                                currentIndex = (currentIndex + 1) % wordManager.words.count
                                showingChinese = false
                            }
                        }
                        .padding()
                    }
                } else {
                    Text("请添加单词")
                }
            }
            .navigationTitle("单词学习")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: StatsView(wordManager: wordManager)) {
                        Image(systemName: "chart.bar")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddWord = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("所有单词") { learningMode = .all }
                        Button("未学习") { learningMode = .notLearned }
                        Button("需要复习") { learningMode = .needReview }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showingAddWord) {
                AddWordView(wordManager: wordManager)
            }
        }
    }
    
    var filteredWords: [Word] {
        switch learningMode {
        case .all:
            return wordManager.words
        case .notLearned:
            return wordManager.words.filter { !$0.learned }
        case .needReview:
            return wordManager.words.filter { word in
                guard let lastReview = word.lastReviewDate else { return true }
                return Date().timeIntervalSince(lastReview) > 24 * 60 * 60 // 24小时
            }
        }
    }
}
