import Foundation

/**
 Mock of the Query used by GraphQL to retrieve the messages
 */

class GraphQLMessagesQuery {
    let after: Int
    let first: Int

    init(after: Int, first: Int) {
        self.after = after
        self.first = first
    }
}
