import SwiftUI

struct StatsView: View {
    @ObservedObject var wordManager: WordManager
    
    var learnedWordsCount: Int {
        wordManager.words.filter { $0.learned }.count
    }
    
    var totalWordsCount: Int {
        wordManager.words.count
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("学习统计")
                .font(.title)
            
            HStack {
                VStack {
                    Text("\(totalWordsCount)")
                        .font(.largeTitle)
                    Text("总单词数")
                }
                .padding()
                
                VStack {
                    Text("\(learnedWordsCount)")
                        .font(.largeTitle)
                    Text("已掌握")
                }
                .padding()
            }
            
            ProgressView(value: Double(learnedWordsCount), total: Double(totalWordsCount))
                .padding()
        }
        .padding()
    }
} 