import os
from googlefinance import getQuotes
from time import sleep

GOOGLE_SYMBOL = "GOOG"
APPLE_SYMBOL = "AAPL"
MICROSOFT_SYMBOL = "MSFT"

PURCHASE_PRICE_KEY = 'last_purchase_price'
PURCHASE_QUANTITY_KEY = 'quantity_purchased'

def get_current_price(symbol):
	return float(getQuotes(symbol)[0]['LastTradePrice'])
	
def should_purchase(last_price, current_price):
	return current_price < last_price
	
def get_purchase_quantity(last_price, price, scale_factor=100):
	price_drop = last_price - price
	return int(price_drop / price * scale_factor)
	
def purchase(quantity, price, purchase_record):
	return purchase_record + [{ PURCHASE_QUANTITY_KEY: quantity, PURCHASE_PRICE_KEY: price }]
	
def get_last_purchase_price(purchase_record):
	if len(purchase_record) > 0: return purchase_record[-1][PURCHASE_PRICE_KEY]
	return None


def initial_purchase(symbol, purchase_record, quantity=-1, max_initial_expenditure=10000):
	initial_price = get_current_price(symbol)
	if quantity == -1: quantity = int(max_initial_expenditure / initial_price)
	print("Initial purchase of", quantity, symbol, "at $", initial_price)
	print()
	return purchase(quantity, initial_price, purchase_record), initial_price


def process(symbol, purchase_record):
	last_price = get_last_purchase_price(purchase_record)
	if last_price is None:
		purchase_record, last_price = initial_purchase(symbol, purchase_record)
	
	price = get_current_price(symbol)
	change = round(price - last_price, 2)
	sign = (('↙', '↗')[change > 0], '↔')[change == 0]
	print(sign, "$", abs(change))
	

	if should_purchase(last_price, price): # Purchase.
		quantity = get_purchase_quantity(last_price, price)
		purchase_record = purchase(quantity, price, purchase_record)
		print("Purchased", quantity, symbol, "at $", price)
		return purchase_record
	else: 
		print("Did not purchase any", symbol)
		return purchase_record
	

def unpack(purchase):
	return purchase[PURCHASE_QUANTITY_KEY], purchase[PURCHASE_PRICE_KEY]
	

def sell_value(symbol, purchase_record):
	current_price = get_current_price(symbol)
	value = 0
	profit = 0
	for purchase in purchase_record:
		quantity, price = unpack(purchase)
		value += quantity * current_price
		profit += quantity * (current_price - price)
	return value, round(profit,2)
	

if __name__ == "__main__":
	print("Quick-digits: Enter 1 for Apple, 2 for Google, or 3 for Microsoft")
	print("Otherwise enter a valid symbol")
	print()
	company = input("Company name or quick-digit: ")

	symbol = GOOGLE_SYMBOL
	if company.lower() in ["apple", "1"]:
		symbol = APPLE_SYMBOL
	elif company.lower() in ["google", "2"]:
		symbol = GOOGLE_SYMBOL
	elif company.lower() in ["microsoft", "3"]:
		symbol = MICROSOFT_SYMBOL
	else:
		symbol = company.upper()

	os.system('cls' if os.name == 'nt' else 'clear')

	purchase_record = []
	while True:
		purchase_record = process(symbol, purchase_record)
		value, profit = sell_value(symbol, purchase_record)
		print("Current portfolio value:", "$", value)
		print("Current portfolio profit:", "$", profit)
		print()
		sleep(60 * 5)