extends Node

func to_entry(_name: String, body: String) -> Dictionary:
	return {
		"name": _name,
		"body": body
	}
