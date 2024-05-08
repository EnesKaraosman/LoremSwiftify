//
//  ContentView.swift
//  Example
//
//  Created by Enes Karaosman on 14.04.2024.
//

import LoremSwiftify
import SwiftUI

extension UIColor {
    static func fromIntToHex(_ rawColor: String) -> UIColor? {
        var hex = String(String(format: "%02X", Int(rawColor)!).reversed())
            .padding(toLength: 6, withPad: "0", startingAt: 0)
        hex = String(hex.reversed())
        return .from(hex: "#\(hex)")
    }
    
    static func from(hex: String) -> UIColor? {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return nil
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

struct ContentView: View {
    let display: ContentView.Display
    
    init(display: ContentView.Display) {
        self.display = display
        debugPrint(UIColor.fromIntToHex(display.developers.first!.color2))
    }

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
                    .foregroundStyle(Color(uiColor: UIColor.from(hex: developer.color)!))
                Text(developer.imageURLString)
                    .foregroundStyle(Color(uiColor: UIColor.fromIntToHex(developer.color2)!))
                Text(developer.date)
                Text(developer.phoneNumber)
                    .font(.footnote)
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

            @Lorem(.string(.phoneNumber))
            let phoneNumber: String

            @Lorem(.url(.image))
            let imageURL: URL
            
            @Lorem(.url(.image))
            let imageURLString: String
            
            @Lorem(.string(.hexColor))
            let color: String
            
            @Lorem(.string(.rgbColor))
            let color2: String
            
            @Lorem(.string(.date))
            let date: String

            @Lorem(.url(.website))
            let profileURL: URL
        }
    }
}

#Preview {
    ContentView(display: .lorem())
}
