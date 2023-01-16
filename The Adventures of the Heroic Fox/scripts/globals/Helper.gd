extends Node

func to_entry(_name: String, body: String, tutorial: int = -1) -> Dictionary:
	return {
		"name": _name,
		"body": body,
		"tutorial": tutorial,
	}
