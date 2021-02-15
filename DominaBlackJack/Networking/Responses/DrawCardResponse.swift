//
//  DrawResponse.swift
//  DominaBlackJack
//
//  Created by Adrian Gallardo on 11/02/21.
//

import Foundation

struct Images: Codable {
	let svg: String
	let png: String
}

struct Card: Codable {
	let code: String
	let image: String
	let images: Images
	let value: String
	let suit: String
}

struct DrawCardResponse: Codable {
	let success: Bool
	let deckId: String
	let cards: [Card]
	let remaining: Int

	enum CodingKeys: String, CodingKey {
		case success
		case deckId = "deck_id"
		case cards
		case remaining
	}
}
