import SwiftUI

struct MessageItemView: View {
    
    let message: Message
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40.0, height: 40.0, alignment: .center)
                .foregroundColor(.primary)
                .padding(.all, 20)
            
            VStack(alignment: .leading, spacing: 5, content: {
                HStack{
                    Text("Id:")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text(String(message.id))
                        .foregroundColor(.primary)
                }
                
                HStack{
                    Text(message.message)
                        .foregroundColor(.primary)
                }
            })
        })
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .background(Color.secondary)
        .cornerRadius(10.0)
        .padding(.vertical, 5)
    }
}

