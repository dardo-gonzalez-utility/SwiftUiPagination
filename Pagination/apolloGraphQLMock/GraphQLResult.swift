import Foundation

/**
 Mock of the GraphQLResult struct defined by GraphQL
 */

public struct GraphQLResult<Data> {
    
    public let data: Data?
    public let errors: [GraphQLError]?

    public init(data: Data?, errors: [GraphQLError]?) {
        self.data = data
        self.errors = errors
    }
}
