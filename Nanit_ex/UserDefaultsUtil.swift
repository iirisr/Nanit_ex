//
//  UserDefaults.swift
//  Nanit_ex
//
//  Created by Iris Ronen on 11/7/21.
//

import Foundation
import UIKit

class UserDefaultsUtil {
    struct UserDefaultsKeyName {
        static let name = "name"
        static let birthdate = "birthdate"
        static let picture = "picture"
    }
    
    func getName()->String? {
        return UserDefaults.standard.object(forKey: UserDefaultsKeyName.name) as? String
    }
    func saveName(_ name: String) {
        UserDefaults.standard.setValue(name, forKey: UserDefaultsKeyName.name)
    }
    
    func getBirthdate()->Date? {
        var date: Date?
        if let userDefaultsDate = UserDefaults.standard.object(forKey: UserDefaultsKeyName.birthdate) as? Date {
            date = userDefaultsDate
            print("UserDefaults for key \(UserDefaultsKeyName.birthdate) is \(date), Date()=\(Date())")
        }
        else {
            print("UserDefaults for key \(UserDefaultsKeyName.birthdate) doesn't exist");
        }
        return date
    }
    func saveBirthdate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: UserDefaultsKeyName.birthdate)
    }
    
    func getPicture()->UIImage? {
        guard let data = UserDefaults.standard.data(forKey:UserDefaultsKeyName.picture) else { return nil}
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let image = UIImage(data: decoded)
        print("getPicture returns image==nil:\(image==nil)")
        return image
    }
    func savePicture(_ picture: UIImage) {
        guard let data = picture.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: UserDefaultsKeyName.picture)
    }
}
