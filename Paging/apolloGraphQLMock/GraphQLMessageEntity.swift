import Foundation

/**
 Mock of the Message entity that returns the GraphQL query
 */

class GraphQLMessageEntity {
    let id: Int
    let message: String
    
    init(id: Int, message: String) {
        self.id = id
        self.message = message
    }
}
