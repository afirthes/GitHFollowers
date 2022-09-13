//
//  ErrorMessage.swift
//  GitHFollowers
//
//  Created by Afir Thes on 13.09.2022.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username creted an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid."
}
