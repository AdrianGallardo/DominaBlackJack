//
//  ReshuffleCardsResponse.swift
//  DominaBlackJack
//
//  Created by Adrian Gallardo on 15/02/21.
//

import Foundation

struct ReshuffleCardsResponse: Codable {
	let success: Bool
	let deckId: String
	let remaining: Int
	let shuffled: String

	enum CodignKeys: String, CodingKey {
		case success
		case deckId = "deck_id"
		case remaining
		case shuffled
	}
}

