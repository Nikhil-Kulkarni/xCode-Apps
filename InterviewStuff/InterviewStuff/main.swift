//
//  main.swift
//  InterviewStuff
//
//  Created by Nikhil Kulkarni on 6/28/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation

/**
 * Checks if a is a permutation of b
 *
 */
func isPermutation(a:String, b:String) -> Bool {
    if count(a) != count(b) {
        return false
    }
    var arr = [Int](count: 128, repeatedValue: 0)
    for c in a {
        arr[c.hashValue]++
    }
    for c in b {
        arr[b.hashValue]--
        if arr[b.hashValue] < 0 {
            return false
        }
    }
    return true
}

println(isPermutation("racecar", "carrace"))


