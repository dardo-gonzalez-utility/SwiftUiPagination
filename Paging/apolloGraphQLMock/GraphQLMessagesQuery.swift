import Foundation

/**
 Mock of the Query used by GraphQL to retrieve the messages
 */

class GraphQLMessagesQuery {
    let page: Int
    
    init(page: Int) {
        self.page = page
    }
}
