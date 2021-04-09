import Dispatch

class RestaurantMenuItems {
	
	let dishes = ["pork", "steak-r", "chicken", "steak-wd"]
	
	func getDishes(_ closure: (_ dishes: [String]?) -> Void) {
		closure(dishes)
	}
}

class RestaurantPrepTimes {
	
	let queue = DispatchQueue(label: "")
	var dish = ""
	
	func getPrepTime(_ closure: @escaping (_ time: Double?) -> Void) {
		
		queue.asyncAfter(deadline: .now() + 2) { // Add a delay
			switch self.dish {
				case "chicken":
					closure(3.0)
					break
				case "pork":
					closure(8.0)
					break
				case "steak-wd":
					closure(18.0)
					break
				case "steak-r":
					closure(5.0)
					break
				default:
					closure(20.0)
					break
			}
		}
	}
}

let restaurant = RestaurantMenuItems()
var d = [String]()

restaurant.getDishes { (dishes) in
	guard let dishesResponse = dishes else {
		return
	}
	d = dishesResponse
	print("The dishes are: \(d)")
}

var dishesWithTimes1 = [(dish: String, prepTime: Double)]()

func pairDishesWithTimesIncorrectly() {
	for dish in d {
		let r = RestaurantPrepTimes()
		r.dish = dish
		r.getPrepTime {(time) in
			guard let t = time else {
				return
			}
			dishesWithTimes1.append((dish: r.dish, prepTime: t))
		}
	}
	print("Done getting dishes: \(dishesWithTimes1)")
}

var dishesWithTimes2 = [(dish: String, prepTime: Double)]()

func pairDishesWithTimesCorrect() {
	let group = DispatchGroup()
	for dish in d {
		group.enter()
		let r = RestaurantPrepTimes()
		r.dish = dish
		r.getPrepTime {(time) in
			guard let t = time else {
				return
			}
			let tuple = (r.dish, t)
			dishesWithTimes2.append(tuple)
			group.leave()
		}
	}
	
	group.notify(queue: .main) {
		print("Actually Done now: \(dishesWithTimes2)")
		dishesWithTimes2 = dishesWithTimes2.sorted { (first, second) -> Bool in
			return first.prepTime < second.prepTime
		}
		print("Sorted dishes by time: \(dishesWithTimes2)")
	}
}

pairDishesWithTimesIncorrectly()
pairDishesWithTimesCorrect()






