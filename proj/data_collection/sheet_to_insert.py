import csv
import pathlib
import os
from pathlib import Path
import csv
from dateutil import parser
from datetime import datetime
import requests
import argparse

parser = argparse.ArgumentParser(description='Convert from Google Spreadsheet to SQL INSERTS.')
parser.add_argument('-f', '--fetch', help='Download the Sheets from online', default=False, action="store_true")
parser.add_argument('-c', '--cache', help='Cache the downloaded sheets', default=False, action="store_true")

args = parser.parse_args()

# I collected all of my data with Ming Wang in a Google Sheet for easy collaboration:
# https://docs.google.com/spreadsheets/d/1e2z-T7NIfCI64aNhVR1FVSrC0_SLr_LBZ0g8vNZGxWk/edit#gid=515588432
# This simple Python file just converts that to INSERT statements I can easily copy into my script.


# Instead of storing country_id, we just write the country code for easy of use, Need to preprocess that
def country_code_to_id(country_code):
	country_codes = ["JAM","USA","KEN","GRN","TTO","BOT","BRN","GBR","AFG","ALB","ALG","AND","ANG","ANT","ARG","ARM","ARU","ASA","AUS","AUT","AZE","BAH","BAN","BAR","BDI","BEL","BEN","BER","BHU","BIH","BIZ","BLR","BOL","BRA","BRU","BUL","BUR","CAF","CAM","CAN","CAY","CGO","CHA","CHI","CHN","CIV","CMR","COD","COK","COL","COM","CPV","CRC","CRO","CUB","CYP","CZE","DEN","DJI","DMA","DOM","ECU","EGY","ERI","ESA","ESP","EST","ETH","FIJ","FIN","FRA","FSM","GAB","GAM","GBS","GEO","GEQ","GER","GHA","GRE","GUA","GUI","GUM","GUY","HAI","HKG","HON","HUN","INA","IND","IRI","IRL","IRQ","ISL","ISR","ISV","ITA","IVB","JOR","JPN","KAZ","KGZ","KIR","KOR","KOS","KSA","KUW","LAO","LAT","LBA","LBN","LBR","LCA","LES","LIE","LTU","LUX","MAD","MAR","MAS","MAW","MDA","MDV","MEX","MGL","MHL","MKD","MLI","MLT","MNE","MON","MOZ","MRI","MTN","MYA","NAM","NCA","NED","NEP","NGR","NIG","NOR","NRU","NZL","OMA","PAK","PAN","PAR","PER","PHI","PLE","PLW","PNG","POL","POR","PRK","PUR","QAT","ROU","RSA","RUS","RWA","SAM","SEN","SEY","SGP","SKN","SLE","SLO","SMR","SOL","SOM","SRB","SRI","SSD","STP","SUD","SUI","SUR","SVK","SWE","SWZ","SYR","TAN","TGA","THA","TJK","TKM","TLS","TOG","TPE","TUN","TUR","TUV","UAE","UGA","UKR","URU","UZB","VAN","VEN","VIE","VIN","YEM","ZAM","ZIM"]
	# The ID is just the country code ID
	return country_codes.index(country_code)

statements = []

def is_edt_date(string):
    return "Eastern Daylight Time" in string

def is_est_date(string):
    return "Eastern Standard Time" in string

def quote(v): 
	return "'{}'".format(v)

def get_values_from_row(row):
	value_str = ""
	for v in row:
		if isinstance(v, int):
			value_str += str(v)
		elif v.isdigit():
			value_str += v
		elif is_edt_date(v):
			d = datetime.strptime(v, '%a %b %d %Y %H:%M:%S %Z%z (Eastern Daylight Time)')
			value_str += quote(d.strftime('%d-%b-%y'))
		elif is_est_date(v):
			d = datetime.strptime(v, '%a %b %d %Y %H:%M:%S %Z%z (Eastern Standard Time)')
			value_str += quote(d.strftime('%d-%b-%y'))
		elif v == '' or v == 'null':
			value_str += 'null'
		else:
			value_str += quote(v)
		value_str += ", "
	return value_str[:-2]


# spreadsheet_gid can be found at the end of the URL when looking at the Google Sheet
GOOGLE_SHEETS_EXPORT_CSV_BASE_URL = "https://docs.google.com/spreadsheets/d/1e2z-T7NIfCI64aNhVR1FVSrC0_SLr_LBZ0g8vNZGxWk/export?format=csv&id=1e2z-T7NIfCI64aNhVR1FVSrC0_SLr_LBZ0g8vNZGxWk&gid={}"
table_metadata = {
	"event_participation": {
		"path": "event_participation.csv",
		"spreadsheet_gid": 286248946,
		"preprocess": False
	},
	"user_role": {
		"path": "user_role.csv",
		"spreadsheet_gid": 1489191300,
		"preprocess": False
	},
	"user_account": {
		"path": "user_account.csv",
		"spreadsheet_gid": 0,
		"preprocess": False
	},
	"participant": {
		"path": "participant.csv",
		"spreadsheet_gid": 727203934,
		"preprocess": False
	},
	"scoreboard": {
		"path": "scoreboard.csv",
		"spreadsheet_gid": 1552712438,
		"preprocess": False
	},
	"medal": {
		"path": "medal.csv",
		"spreadsheet_gid": 199482739,
		"preprocess": False
	},
	"team_member": {
		"path": "team_member.csv",
		"spreadsheet_gid": 749005406,
		"preprocess": False
	},
	"country": {
		"path": "country.csv",
		"spreadsheet_gid": 494451539,
		"preprocess": False
	},
	"sport": {
		"path": "sport.csv",
		"spreadsheet_gid": 534675641,
		"preprocess": False
	},
	"event": {
		"path": "event.csv",
		"spreadsheet_gid": 486972009,
		"preprocess": False
	},
	"venue": {
		"path": "venue.csv",
		"spreadsheet_gid": 1965294659,
		"preprocess": False
	},
	"team": {
		"path": "team.csv",
		"spreadsheet_gid": 515588432,
		"preprocess": {
			"function": country_code_to_id,
			"col": 3
		}
	},
	"olympics": {
		"path": "olympics.csv",
		"spreadsheet_gid": 467710884,
		"preprocess": False
	}
}

def csv_to_inserts(table_name, csv_data, preprocess):
	reader = csv.reader(csv_data)
	headers = next(reader, None)
	ignored_col_count = headers.count('ignore')
	for row in reader:
		print(row)
		if row[1] == '':
			# We have some extra rows that are not filled in, just skip those
			break
		sanitized_row = row[:-ignored_col_count] if ignored_col_count > 0 else row
		if preprocess:
			col = preprocess["col"]
			sanitized_row[col] = preprocess["function"](sanitized_row[col])
		values = get_values_from_row(sanitized_row)
		stmt = 'INSERT INTO {} values({});'.format(table_name.upper(), values)
		statements.append(stmt)

table_insertion_order = ["user_role", "user_account", "olympics", 
						"country", "sport", "venue", "event", "medal", 
						"participant", "team", "team_member", 
						"event_participation", "scoreboard"]

def get_csv_data(table_name):
	metadata = table_metadata[table_name]
	if "spreadsheet_gid" in metadata and args.fetch:
		spreadsheet_url = GOOGLE_SHEETS_EXPORT_CSV_BASE_URL.format(metadata["spreadsheet_gid"])
		print("Fetching", table_name, "Spreadsheet ID:", metadata["spreadsheet_gid"])
		res=requests.get(url=spreadsheet_url)
		csv_raw_data = res.content.decode('utf-8')
		csv_data = csv_raw_data.splitlines()
		if args.cache:
			with open(metadata['path'], 'w') as f:
				f.write(csv_raw_data)
				f.close()
	else:
		csv_path = metadata['path']
		f = open(csv_path, "r")
		csv_data = f
	return csv_data

def run():
	for table_name in table_insertion_order:
		metadata = table_metadata[table_name]
		csv_data = get_csv_data(table_name)
		insert_stmts = csv_to_inserts(table_name, csv_data, metadata['preprocess'])
		statements.append('\n')

run()

print('\n')
print("\n".join(statements))