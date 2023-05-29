import Foundation

/**
 Mock of the GraphQLError struct defined by GraphQL
 */

public struct GraphQLError: Error {
    var _message: String
    
    init(_ message: String) {
        _message = message
    }
    
    /// A description of the error.
    public var message: String? {
        return _message
    }
}

extension GraphQLError: CustomStringConvertible {
  public var description: String {
    return self.message ?? "GraphQL Error"
  }
}

extension GraphQLError: LocalizedError {
  public var errorDescription: String? {
    return self.description
  }
}
