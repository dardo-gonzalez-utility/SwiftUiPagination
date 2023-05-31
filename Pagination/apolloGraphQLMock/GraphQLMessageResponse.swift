import Foundation

/**
 Mock of the Message entity that returns the GraphQL query
 */

class GraphQLMessageSummary {
    let totalCount: Int
    let messages: [GraphQLMessageEntity]
    
    init(totalCount: Int, messages: [GraphQLMessageEntity]) {
        self.totalCount = totalCount
        self.messages = messages
    }
}

class GraphQLMessageEntity {
    let messageId: Int
    let message: String
    
    init(id: Int, message: String) {
        self.messageId = id
        self.message = message
    }
}
