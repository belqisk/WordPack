import SwiftUI

struct ContentView: View {
    @StateObject private var wordManager = WordManager()
    @State private var showingChinese = false
    @State private var showingAddWord = false
    @State private var showingAnswer = false
    
    var body: some View {
        NavigationView {
            VStack {
                if !wordManager.words.isEmpty {
                    // 进度条
                    ProgressView(value: wordManager.progress)
                        .padding()
                    
                    // 当前单词
                    VStack(spacing: 20) {
                        if wordManager.reviewMode != .hideEnglish {
                            Text(wordManager.words[wordManager.currentIndex].english)
                                .font(.largeTitle)
                                .padding()
                                .onTapGesture {
                                    wordManager.speakWord(wordManager.words[wordManager.currentIndex].english)
                                }
                        }
                        
                        if showingAnswer || wordManager.reviewMode != .hideChinese {
                            Text(wordManager.words[wordManager.currentIndex].chinese)
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 按钮组
                    VStack {
                        if !showingAnswer {
                            Button("显示答案") {
                                showingAnswer = true
                            }
                            .padding()
                        } else {
                            HStack(spacing: 30) {
                                Button(action: {
                                    wordManager.markCurrentWordAsWrong()
                                    nextWord()
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                }
                                
                                Button(action: {
                                    wordManager.markCurrentWordAsCorrect()
                                    nextWord()
                                }) {
                                    Image(systemName: "checkmark.circle")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // 学习统计
                    if let word = wordManager.words[safe: wordManager.currentIndex] {
                        HStack {
                            Label("\(word.correctCount)", systemImage: "checkmark.circle")
                                .foregroundColor(.green)
                            Spacer()
                            Label("\(word.wrongCount)", systemImage: "xmark.circle")
                                .foregroundColor(.red)
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
    
    private func nextWord() {
        wordManager.currentIndex = (wordManager.currentIndex + 1) % wordManager.words.count
        showingAnswer = false
    }
}

// 安全数组访问扩展
extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
