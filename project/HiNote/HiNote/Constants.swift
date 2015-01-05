//
//  Constants.swift
//  HiNote
//
//  Created by cameron on 12/16/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//
import Foundation

//Struct holding constants
struct Constants {
    
    //base url to reach the server
    static let baseUrl: String = "http://mlbvsnba.no-ip.org:8000/"
}

// Constant function to set the username from KeyChain
func setUsername(username: String) {
    NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
    NSUserDefaults.standardUserDefaults().synchronize()
}

// Constant function to get the username from the KeyChain
func getUsername() -> String {
    return NSUserDefaults.standardUserDefaults().objectForKey("username") as String
}


//Class that allows access to the KeyChain
class KeychainAccess: NSObject {

    /*
    * Set the passcode for the keychain
    * @param identifier: identifier
    * @param passcode: the passcode as a string
    */
    func setPasscode(identifier: String, passcode: String) {
        //Encode
        var dataFromPasscode: NSData = passcode.dataUsingEncoding(NSUTF8StringEncoding)!;
        
        //Store
        var keychainQuery = NSDictionary(
            objects: [kSecClassGenericPassword, identifier, dataFromPasscode],
            forKeys: [kSecClass, kSecAttrService, kSecValueData])
        
        SecItemDelete(keychainQuery as CFDictionaryRef);
        var status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil);
        
        print("keychainWorked?: \(status)")
    }
    
    /*
    * Get the passcode for the keychain
    * @param identifier: identifier
    * @return the passcode as a string
    */
    func getPasscode(identifier: String) -> String? {
        //encode
        var keychainQuery = NSDictionary(
            objects: [kSecClassGenericPassword, identifier, kCFBooleanTrue, kSecMatchLimitOne],
            forKeys: [kSecClass, kSecAttrService, kSecReturnData, kSecMatchLimit])
        var dataTypeRef :Unmanaged<AnyObject>?;
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef);
        let opaque = dataTypeRef?.toOpaque();
        var passcode: String?;
        
        //Check if data is received, if so make password string
        if let op = opaque? {
            let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue();
            passcode = NSString(data: retrievedData, encoding: NSUTF8StringEncoding);
            println(passcode)
        } else {
            println("Passcode not found. Status code \(status)");
        }
        return passcode;
    }
}

/* Constant function to set the password in the KeyChain
 * @param: the password as a string
*/
func setPasscode(passcode: String) {
    var keychainAccess = KeychainAccess();
    keychainAccess.setPasscode("CAMCAMSAPP", passcode:passcode);
}


func getPasscode() -> String {
    var keychainAccess = KeychainAccess();
    return keychainAccess.getPasscode("CAMCAMSAPP")!;
}