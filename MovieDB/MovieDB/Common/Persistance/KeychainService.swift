//
//  KeychainService.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 04.03.2025.
//

import Security
import Foundation

final class KeychainService {
    private let service = "com.dufrane.MovieDB"

// MARK: - Save API Key
    func saveAPIKey(_ apiKey: String) {
        guard let data = apiKey.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

// MARK: - Get API Key
    func getAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == noErr {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }

// MARK: - Delete API Key
    func deleteAPIKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("API Key successfully deleted from Keychain.")
        } else {
            print("Failed to delete API Key: \(status)")
        }
    }

// MARK: - Validate API Key
    func validateAPIKey(completion: @escaping (Bool) -> Void) {
        guard let apiKey = getAPIKey() else {
            completion(false)
            return
        }

        let url = URL(string: "https://api.themoviedb.org/3/authentication")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let success = jsonResponse["success"] as? Bool, success {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }.resume()
    }
}
