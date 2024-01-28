import Foundation

enum Operator {
    case not
    case and
    case or
    case xor
    case implies
    case equals
    case notEquals
}

let operatorDictionary: [String : Character] = [
    "and" : "∧",
    "not" : "¬",
    "or" : "∨",
    "xor" : "⊕",
    "imply" : "→",
    "implies" : "→",
    "equals" : "=",
    "notequals" : "≠",
    "true": "⊤",
    "false": "⊥"
]

// GPTed
func evaluateExpression(_ expression: String) -> Bool {
    var stack = [Bool]()
    var operators = [Operator]()

    let tokens = expression.split(separator: " ")

    for token in tokens {
        switch token.lowercased() {
        case "true":
            stack.append(true)
        case "false":
            stack.append(false)
        case "not":
            operators.append(.not)
        case "and":
            operators.append(.and)
        case "or":
            operators.append(.or)
        case "xor":
            operators.append(.xor)
        case "implies":
            operators.append(.implies)
        case "equals":
            operators.append(.equals)
        case "notequals":
            operators.append(.notEquals)
        default:
            stack.append(token.lowercased() == "true")
        }
    }

    while !operators.isEmpty {
        let operatorType = operators.removeFirst()
        evaluateTopOperator(&stack, operatorType)
    }

    return stack.last ?? false
}

func evaluateTopOperator(_ stack: inout [Bool], _ operatorType: Operator) {
    let rightOperand = operatorType == .not ? nil : stack.popLast()
    let leftOperand = operatorType == .not ? nil : stack.popLast()

    switch operatorType {
    case .not:
        let operand = stack.removeFirst()
        stack.insert(!operand, at: 0)
    case .and:
        stack.append(leftOperand! && rightOperand!)
    case .or:
        stack.append(leftOperand! || rightOperand!)
    case .xor:
        stack.append(leftOperand! != rightOperand!)
    case .implies:
        stack.append(!leftOperand! || rightOperand!)
    case .equals:
        stack.append(leftOperand! == rightOperand!)
    case .notEquals:
        stack.append(leftOperand! != rightOperand!)
    }
}

func evaluateParenthesis(_ expression: String) -> String {
    var expression = expression
    var parenthesisCount = 0

    for character in expression {
        if character == "(" {
            parenthesisCount += 1
        } else if character == ")" {
            parenthesisCount -= 1
        }
    }

    if parenthesisCount > 0 {
        fatalError("Mismatched parentheses: Found an opening parenthesis without a matching closing parenthesis.")
    } else if parenthesisCount < 0 {
        fatalError("Mismatched parentheses: Found a closing parenthesis without a matching opening parenthesis.")
    }

    while let startIndex = expression.lastIndex(of: "(") {
        guard let endIndex = expression[startIndex...].firstIndex(of: ")") else {
            break
        }

        let start = expression.index(after: startIndex)
        let end = expression.index(before: endIndex)
        let subExpression = String(expression[start...end])
        let result = evaluateExpression(subExpression)
        expression.replaceSubrange(startIndex...endIndex, with: result.description)
    }

    return expression
}

func generateTruthTable(_ formula: String, result: Bool) {
    let redPrefix = "\u{001B}[0;31m"
    let greenPrefix = "\u{001B}[0;32m"
    let resetSuffix = "\u{001B}[0;0m"

    // Print table top border
    let headerRow = "+\(String(repeating: "-", count: formula.count + 8))+" // Each variable takes 4 characters
    print(headerRow)

    // Print formula row
    let formattedFormula = "|    \(formula)    |"
    print(formattedFormula)

    // Print table mid border
    print(headerRow)

    let numberOfSpacesNeeded = ((formula.count + 8) - (result ? 4 : 5)) / 2
    let numberOfOddSpacesNeeded = numberOfSpacesNeeded % 2 == 0 ? numberOfSpacesNeeded : numberOfSpacesNeeded + 1
    let evenSpaces = String(repeating: " ", count: numberOfSpacesNeeded)
    let oddSpaces = String(repeating: " ", count: numberOfOddSpacesNeeded)
    let formattedResult = "|\(evenSpaces)\(result ? "\(greenPrefix)TRUE\(resetSuffix)" : "\(redPrefix)FALSE\(resetSuffix)")\(oddSpaces)|"
    print(formattedResult)

    // Print table bottom border
    print(headerRow)
}

// GPTed
func replaceTextWithDictionary(input: String, dictionary: [String: String]) -> String {
    var replacedString = input

    for (key, value) in dictionary {
        replacedString = replacedString.replacingOccurrences(of: key + " ", with: value + " ")
        replacedString = replacedString.replacingOccurrences(of: " " + key + " ", with: " " + value + " ")
        replacedString = replacedString.replacingOccurrences(of: " " + key, with: " " + value)
    }

    return replacedString
}

while let input = readLine() {
    let replacementDictionary = [
        "and": "∧",
        "or": "∨",
        "xor": "⊕",
        "imply": "→",
        "=": "=",
        "!=": "≠",
        "not": "¬",
        "true": "T",
        "false": "F"
    ]

    if input == "quit" || input == "q" {
        print("Exited Boolean Expression Evaluator")
        break
    }

    let evaluatedExpression = evaluateParenthesis(input)
    let result = evaluateExpression(evaluatedExpression)
    let formattedFormula = replaceTextWithDictionary(input: input, dictionary: replacementDictionary)
    generateTruthTable(formattedFormula, result: result)
}
