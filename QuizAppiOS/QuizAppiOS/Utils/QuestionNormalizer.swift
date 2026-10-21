import Foundation

struct QuestionNormalizer {
    static func normalize(_ text: String) -> String {
        // 修复第68行：清理乱码，只保留标准的中英文引号和空格处理
        let cleaned = text
            .trimmingCharacters(in: CharacterSet(charactersIn: "\"'“”‘’"))
            .replacingOccurrences(of: "\r\n", with: "\n")
        
        return cleaned
    }
    
    // 修复第85行：拆分复杂的表达式
    static func splitOptions(_ s: String) -> [String] {
        let separators = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "，、,;；"))
        return s.components(separatedBy: separators).filter { !$0.isEmpty }
    }
}
