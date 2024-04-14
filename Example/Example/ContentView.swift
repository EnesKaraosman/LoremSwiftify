//
//  ContentView.swift
//  Example
//
//  Created by Enes Karaosman on 14.04.2024.
//

import LoremSwiftify
import SwiftUI

struct ContentView: View {
    let display: ContentView.Display

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(display.developers) { developer in
                    itemView(developer)
                }
            }
            .padding()
        }
    }

    private func itemView(_ developer: Display.Developer) -> some View {
        HStack {
            AsyncImage(
                url: developer.imageURL,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    Color.gray
                        .frame(width: 80, height: 80)
                        .overlay {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                }
            )
            .frame(width: 80)
            .mask(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading) {
                Text(developer.name)
                Text(developer.email)
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, lineWidth: 1)
        )
        .onTapGesture {
            print(developer.profileURL)
        }
    }
}

extension ContentView {
    @LoremSwiftify
    struct Display {
        let developers: [Developer]

        @LoremSwiftify
        struct Developer: Identifiable {
            let id: String = UUID().uuidString

            @Lorem(.string(.name))
            let name: String

            @Lorem(.string(.email))
            let email: String

            @Lorem(.url(.image))
            let imageURL: URL

            @Lorem(.url(.website))
            let profileURL: URL
        }
    }
}

#Preview {
    ContentView(display: .lorem())
}
