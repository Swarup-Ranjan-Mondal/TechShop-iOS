//
//  RadioButtonGroups.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 18/01/21.
//

import SwiftUI
import MapKit

private struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let textSize: CGFloat
    let isMarked: Bool
    let callback: (String) -> ()
    
    init(
        id: String,
        label: String,
        size: CGFloat = 24,
        textSize: CGFloat = 18,
        isMarked: Bool = false,
        callback: @escaping (String) -> ()
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action: {
            self.callback(self.id)
        }) {
            HStack {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                    .foregroundColor(self.isMarked ? .blue : .black)
                Text(label)
                    .font(.system(size: self.textSize ))
                    .foregroundColor(.black)
                Spacer()
            }
        }
    }
}

struct RadioButtonGroups: View {
    let options: [String]
    let callback: (String) -> ()
    
    @State var selected: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<options.count, id: \.self) {
                RadioButtonField(
                    id: options[$0],
                    label: options[$0],
                    isMarked: selected == options[$0],
                    callback: radioGroupCallback
                )
            }
        }
    }
    
    func radioGroupCallback(id: String) {
        selected = id
        callback(id)
    }
}

struct RadioButtonGroups_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World!")
    }
}
