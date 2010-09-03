/*	Better Oblivion Sorting Software
	
	Quick and Dirty Load Order Utility
	(Making C++ look like the scripting language it isn't.)

    Copyright (C) 2009-2010  Random/Random007/jpearce & the BOSS development team
    http://creativecommons.org/licenses/by-nc-nd/3.0/

	$Revision$, $Date$
*/

#include "Globals.h"

namespace boss {
	using namespace std;

	ifstream order;						//masterlist.txt - the grand mod order list
	ofstream bosslog;					//BOSSlog.txt - output file.
	bool fcom;							//true if key FCOM files are found.
	bool ooo;                      	 	//true if OOO esm is found.
	bool bc;                        	//true if Better Cities esm is found.
	bool fook2;							//true if key FOOK2 files are found.
	bool fwe;							//true if FWE esm is found
};