//
//  File.swift
//  DominaBlackJack
//
//  Created by Adrian Gallardo on 13/02/21.
//

import Foundation

struct ShuffleDecksResponse: Codable {
	let success: Bool
	let deckId: String
	let remaining: Int
	let shuffled: Bool

	enum CodingKeys: String, CodingKey {
		case success
		case deckId = "deck_id"
		case remaining
		case shuffled
	}
}
