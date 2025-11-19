//
//  APIConfig.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/13/25.
//

import Foundation

// MARK: - API Configuration
// This shows multiple ways to securely store your API key

struct APIConfig {
    
    // OPTION 1: Environment Variable (Recommended for Development)
    // Add your API key in Xcode: Edit Scheme > Run > Arguments > Environment Variables
    static var openAIKey: String {
        if let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] {
            return key
        }
        
        // OPTION 2: Info.plist (for development)
        // Add OPENAI_API_KEY to your Info.plist
        if let key = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String {
            return key
        }
        
        // OPTION 3: Config.plist file (not committed to git)
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let key = config["OPENAI_API_KEY"] as? String {
            return key
        }
        
        // FALLBACK: Return empty string (will cause API to fail with clear error)
        print("⚠️ WARNING: No OpenAI API key found. Please configure one.")
        return ""
    }
    
    // PRODUCTION: Use a secure backend
    // Never store API keys in production iOS apps!
    // Instead, create a backend service that:
    // 1. Receives requests from your app
    // 2. Adds the API key server-side
    // 3. Calls OpenAI
    // 4. Returns the response to your app
}

// MARK: - Keychain Helper (Most Secure for Production)
class KeychainHelper {
    
    static func save(key: String, value: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // Delete any existing item
        SecItemAdd(query as CFDictionary, nil)
    }
    
    static func get(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        if let data = result as? Data,
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        
        return nil
    }
    
    static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Usage Examples

/*
 
 HOW TO SET UP YOUR API KEY:
 
 ═══════════════════════════════════════════════════════════════
 DEVELOPMENT OPTIONS:
 ═══════════════════════════════════════════════════════════════
 
 OPTION 1: Environment Variable (Easiest for Development)
 ───────────────────────────────────────────────────────────────
 1. In Xcode, go to: Product > Scheme > Edit Scheme
 2. Select "Run" in the left sidebar
 3. Go to "Arguments" tab
 4. Under "Environment Variables" click "+"
 5. Add:
    Name: OPENAI_API_KEY
    Value: sk-your-actual-key-here
 
 
 OPTION 2: Config.plist File
 ───────────────────────────────────────────────────────────────
 1. Create a new file: Config.plist
 2. Add it to .gitignore so it's not committed
 3. Add your key to the plist:
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>OPENAI_API_KEY</key>
        <string>sk-your-actual-key-here</string>
    </dict>
    </plist>
 
 
 OPTION 3: Keychain (Most Secure for Production Testing)
 ───────────────────────────────────────────────────────────────
 // Save the key once (e.g., in a setup screen or on first launch):
 KeychainHelper.save(key: "openai_api_key", value: "sk-your-actual-key-here")
 
 // Then retrieve it:
 if let apiKey = KeychainHelper.get(key: "openai_api_key") {
     // Use the key
 }
 
 
 ═══════════════════════════════════════════════════════════════
 PRODUCTION: Use a Backend Service
 ═══════════════════════════════════════════════════════════════
 
 For production apps, NEVER store API keys in the app.
 Instead, create a backend service:
 
 1. Create a simple API endpoint (Node.js, Python, Swift Vapor, etc.)
 2. Your iOS app calls YOUR backend
 3. Your backend adds the OpenAI API key
 4. Your backend calls OpenAI
 5. Your backend returns the response to your app
 
 Example backend endpoint (Node.js/Express):
 
 app.post('/api/chat', async (req, res) => {
   const { messages, userPreferences } = req.body;
   
   const response = await fetch('https://api.openai.com/v1/chat/completions', {
     method: 'POST',
     headers: {
       'Content-Type': 'application/json',
       'Authorization': `Bearer ${process.env.OPENAI_API_KEY}` // Stored server-side
     },
     body: JSON.stringify({
       model: 'gpt-4',
       messages: messages,
       temperature: 0.7
     })
   });
   
   const data = await response.json();
   res.json(data);
 });
 
 Then modify OpenAIService.swift to call your backend instead of OpenAI directly.
 
 */
