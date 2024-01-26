enum Operator {
    case and
    case or
    case not
}

func evaluateExpression(_ expression: String) -> Bool {
    var stack = [Bool]()
    var operators = [Operator]()
    
    let tokens = expression.split(separator: " ")
    
    for token in tokens {
        switch token {
        case "true":
            stack.append(true)
        case "false":
            stack.append(false)
        case "and":
            operators.append(.and)
        case "or":
            operators.append(.or)
        case "not":
            operators.append(.not)
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
    case .and:
        stack.append(leftOperand! && rightOperand!)
    case .or:
        stack.append(leftOperand! || rightOperand!)
    case .not:
        let operand = stack.removeFirst()
        stack.insert(!operand, at: 0)
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

while let input = readLine() {
    let redPrefix = "\u{001B}[0;31m"
    let greenPrefix = "\u{001B}[0;32m"
    let resetSuffix = "\u{001B}[0;0m"
    
    if input == "quit" || input == "q" {
        print("Exited Boolean Expression Evaluator")
        break
    }
    
    let evaluatedExpression = evaluateParenthesis(input)
    let result = evaluateExpression(evaluatedExpression)
    print("Result: \(result ? "\(greenPrefix)TRUE\(resetSuffix)" : "\(redPrefix)FALSE\(resetSuffix)")")
}
