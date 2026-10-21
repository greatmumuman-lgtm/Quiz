import Foundation

struct QuestionNormalizer {
    // 针对 Question 对象的清洗（供 BuiltInBankImporter 和 ViewModels 调用）
    static func normalize(_ question: Question) -> Question {
        var q = question
        q.content = cleanText(question.content)
        q.options = question.options.map { cleanText($0) }
        q.answer = cleanText(question.answer)
        q.analysis = cleanText(question.analysis)
        return q
    }
    
    // 针对普通文本的清洗
    static func normalize(_ text: String) -> String {
        return cleanText(text)
    }
    
    // 底层清理逻辑
    private static func cleanText(_ text: String) -> String {
        return text
            .trimmingCharacters(in: CharacterSet(charactersIn: "\"'“”‘’"))
            .replacingOccurrences(of: "\r\n", with: "\n")
    }
}
