import Foundation

/**
 Message DTO used in the app
 */

struct Message: Hashable, Identifiable {
    let id: Int
    let message: String
    
    init(id: Int, message: String) {
        self.id = id
        self.message = message
    }
    
    // Convert GraphQL message to app DTO message
    init(graphQLMessageEntity: GraphQLMessageEntity) {
        self.id = graphQLMessageEntity.messageId
        self.message = graphQLMessageEntity.message
    }
}

