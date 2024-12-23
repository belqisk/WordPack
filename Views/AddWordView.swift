import SwiftUI

struct AddWordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var wordManager: WordManager
    
    @State private var english = ""
    @State private var chinese = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("英文", text: $english)
                TextField("中文", text: $chinese)
                
                Button("添加单词") {
                    if !english.isEmpty && !chinese.isEmpty {
                        let newWord = Word(english: english, chinese: chinese)
                        wordManager.addWord(newWord)
                        dismiss()
                    }
                }
                .disabled(english.isEmpty || chinese.isEmpty)
            }
            .navigationTitle("添加新单词")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
} 