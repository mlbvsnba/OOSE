//
//  Constants.swift
//  HiNote
//
//  Created by cameron on 12/16/14.
//  Copyright (c) 2014 cameron. All rights reserved.
//
import Foundation

struct Constants {
static let baseUrl: String = "http://mlbvsnba.no-ip.org:8000/"
}

class KeychainAccess: NSObject {
    
    
    func setPasscodeAndUsername(identifier: String, passcode: String, username: String) {
        var dataFromString: NSData = passcode.dataUsingEncoding(NSUTF8StringEncoding)!;
        var keychainQuery = NSDictionary(
            objects: [kSecClassGenericPassword, identifier, dataFromString],
            forKeys: [kSecAttrAccount, kSecClass, kSecAttrService, kSecValueData])
        
        SecItemDelete(keychainQuery as CFDictionaryRef);
        var status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil);
    }
    
    func getPasscode(identifier: String) -> String? {
        var keychainQuery = NSDictionary(
            objects: [kSecClassGenericPassword, identifier, kCFBooleanTrue, kSecMatchLimitOne],
            forKeys: [kSecClass, kSecAttrService, kSecReturnData, kSecMatchLimit])
        var dataTypeRef :Unmanaged<AnyObject>?;
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef);
        let opaque = dataTypeRef?.toOpaque();
        var passcode: String?;
        if let op = opaque? {
            let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue();
            passcode = NSString(data: retrievedData, encoding: NSUTF8StringEncoding);
        } else {
            println("Passcode not found. Status code \(status)");
        }
        return passcode;
    }
}

func setPasscode(passcode: String) {
    var keychainAccess = KeychainAccess();
   // keychainAccess.setPasscode("CAMCAMSAPP", passcode:passcode);
}


func getPasscode() -> String {
    var keychainAccess = KeychainAccess();
    return keychainAccess.getPasscode("CAMCAMSAPP")!;
}