//
// RegexTesting.cpp : Defines the entry point for the console application.


#include "Support/Types.h"
#include "Support/Helpers.h"
#include "Support/ModFormat.h"

#include <boost/format.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/filesystem/path.hpp>
#include <boost/filesystem/convenience.hpp>
#include <boost/filesystem/operations.hpp>
#include <string>
#include <iostream>
#include <iomanip>
#include <fstream>


using namespace std;
using namespace boost::filesystem;
using namespace boost::algorithm;
using namespace boss;


string Get(istream& iss)
{
	string value = GetLine(iss);
	if (value.empty()) {
		throw runtime_error("No more data to read.");
	}

	return value;
}

string Consume(string& data, const string value)
{
	static boost::format InvalidInputError = boost::format("Invalid input file format. Expected: '%1%' but found '%2%'");

	trim(data);
	if (!starts_with(data, value)) {
		throw runtime_error((InvalidInputError % value % data).str().c_str());
	}
	replace_first(data, value, "");

	return data;
}

int main(int argc, char* argv[])
{
	try
	{
		path root = current_path();
	
		path inname = root / "VersionCheck.txt";
	
		ifstream in(inname.filename().c_str());
	
		cout << "Reading: " << inname.filename() << endl << endl;
	
		string line;
		int total = 0;
		int failures = 0;
		while (GetLine(in, line)) {
	
			string modfile = Consume(line, "FILENAME:");
	
			line = Get(in);
			string descr = Consume(line, "DESCRIP:");
			string text = ParseVersion(replace_all_copy(descr, "|", "\n"));
	
			line = Get(in);
			string version = Consume(line, "VERSION:");		
	
			bool ok = equals(text, version);
			string state = "OK";
			if (!ok) {
				state = "Failed";
				++failures;
			}

			bool print = !ok;
			if (argc > 1 && equals(argv[1], "--all")) {
				print = true;
			}

			if (print){
				cout << (boost::format("%1%: %2%.\n - Expected: [%3%]\n - Extracted: [%4%]\n - Description: [%5%]") % modfile % state % version % text % descr).str() << endl << endl;
			}

			++total;
		}
		
		cout << "Total processed: " << total << ", failed: " << failures << endl;

		return 0;
	}
	catch (exception& e)
	{
		cerr << "Error: " << e.what() << endl;
		return 1;
	}
}
