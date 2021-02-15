//
//  DBJClient.swift
//  DominaBlackJack
//
//  Created by Adrian Gallardo on 10/02/21.
//

import Foundation

class DBJClient {
	static var deckId = ""

//	MARK: -  Class Functions

//	TODO: Implement these functions
	class func shuffleDecks(numberOfDecks: Int, completion: @escaping (Bool, Error?) -> Void) {
		guard let url = Endpoints.shuffleTheCards(numberOfDecks: numberOfDecks).url else {
			print("shuffleDecks URL error")
			return
		}

		taskForGETRequest(url: url, response: ShuffleDecksResponse.self) { (response, error) in
			if let response = response {
				deckId = response.deckId
				completion(true, nil)
			} else {
				completion(false, error)
			}
		}
	}

	class func drawACard(numberOfCards: Int, completion: @escaping([Card]?, Error?) -> Void) {
		guard let url = Endpoints.drawACard(numberOfCards: numberOfCards).url else {
			print("drawACard URL error")
			return
		}

		taskForGETRequest(url: url, response: DrawCardResponse.self) { (response, error) in
			if let response = response {
				completion(response.cards, nil)
			} else {
				completion([], error)
			}
		}
	}

	class func reshuffleCards(completion: @escaping (Bool, Error?) -> Void) {
		guard let url = Endpoints.reshuffleTheCards.url else {
			print("reshuffleCards URL error")
			return
		}

		taskForGETRequest(url: url, response: ReshuffleCardsResponse.self) { (response, error) in
			if error != nil {
				completion(true, nil)
			} else {
				completion(false, error)
			}
		}
	}

	class func downloadCardImage(cardImageURL: String, completion: @escaping (Data?, Error?) -> Void) {
		guard let url = URL(string: cardImageURL) else {
			print("Card Image URL error")
			return
		}

		let imageTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
			DispatchQueue.main.async {
				completion(data, error)
			}
		}
		imageTask.resume()
	}

//	MARK: - GET Task
	class func taskForGETRequest<ResponseType: Decodable>(url: URL?, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void) {
		print("client: taskForGETRequest")
		guard let url = url else {
			return
		}

		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			print("client taskForGETRequest: data -> " + String(data: data!, encoding: .utf8)!)
			guard let data = data else {
				DispatchQueue.main.async {
					completion(nil, error)
				}
				return
			}

			let decoder = JSONDecoder()
			do {
				let responseObject = try decoder.decode(ResponseType.self, from: data)
				DispatchQueue.main.async {
					completion(responseObject, nil)
				}
			} catch {
				print("client taskForGETRequest: " +  error.localizedDescription)
				DispatchQueue.main.async {
					completion(nil, error)
				}
			}
		}
		task.resume()
	}

}

//MARK: - Endpoints
extension DBJClient {
	enum Endpoints {
		static let base = "https://deckofcardsapi.com/api/deck"

		case shuffleTheCards(numberOfDecks: Int)
		case drawACard(numberOfCards: Int)
		case reshuffleTheCards

		var stringValue: String {
			switch self {
			case .shuffleTheCards(let numberOfDecks): return Endpoints.base + "/new/shuffle/?deck_count=\(numberOfDecks)"
			case .drawACard(let numberOfCards): return Endpoints.base + "/\(DBJClient.deckId)/draw/?count=\(numberOfCards)"
			case .reshuffleTheCards: return Endpoints.base + "/\(DBJClient.deckId)/shuffle/"
			}
		}

		var url: URL? {
			return URL(string: stringValue)
		}
	}
}
