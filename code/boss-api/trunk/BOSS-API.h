/*	BOSS

	A "one-click" program for users that quickly optimises and avoids 
	detrimental conflicts in their TES IV: Oblivion, Nehrim - At Fate's Edge, 
	TES V: Skyrim, Fallout 3 and Fallout: New Vegas mod load orders.

    Copyright (C) 2011    BOSS Development Team.

	This file is part of BOSS.

    BOSS is free software: you can redistribute 
	it and/or modify it under the terms of the GNU General Public License 
	as published by the Free Software Foundation, either version 3 of 
	the License, or (at your option) any later version.

    BOSS is distributed in the hope that it will 
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with BOSS.  If not, see 
	<http://www.gnu.org/licenses/>.

	$Revision: 2188 $, $Date: 2011-01-20 10:05:16 +0000 (Thu, 20 Jan 2011) $
*/

#ifndef BOSSAPI_H
#define BOSSAPI_H

#include <stdint.h>

#if defined(_WIN32) || defined(_WIN64)
//MSVC doesn't support C99, so do the stdbool.h definitions ourselves.
//START OF stdbool.h DEFINITIONS. 
#	ifndef __cplusplus
#		define bool	_Bool
#		define true	1
#		define false   0
#	endif
#	define __bool_true_false_are_defined   1
//END OF stdbool.h DEFINITIONS.
#else
#	include <stdbool.h>
#endif

#if defined(_WIN32) || defined(_WIN64)
#	ifndef _UNICODE
#		define _UNICODE	// Tell compiler we're using Unicode, notice the _
#	endif

// set up dll import/export decorators
// when compiling the dll on windows, ensure BOSS_EXPORT is defined.  clients
// that use this header do not need to define anything to import the symbols
// properly.
#   ifdef BOSS_EXPORT
#       define BOSS_API __declspec(dllexport)
#   else
#       define BOSS_API __declspec(dllimport)
#   endif
#else
#   define BOSS_API
#endif

#ifdef __cplusplus
extern "C"
{
#endif

////////////////////////
// Types
////////////////////////

// All API strings are uint8_t* strings encoded in UTF-8. Strings returned
// by the API should not have their memory freed by the client: the API will
// clean up after itself.
// All API numbers and error codes are uint32_t integers.

// Abstracts the definition of BOSS's internal state while still providing
// type safety across the API.
typedef struct _boss_db_int * boss_db;

// BashTag structure gives the Unique ID number (UID) for each Bash Tag and 
// the corresponding Tag name string.
typedef struct {
    uint32_t id;
    const uint8_t * name;  // don't use char for utf-8 since char can be signed
} BashTag;

// The following are the possible codes that the API can return.
BOSS_API extern const uint32_t BOSS_API_OK;
BOSS_API extern const uint32_t BOSS_API_OK_NO_UPDATE_NECESSARY;
BOSS_API extern const uint32_t BOSS_API_WARN_BAD_FILENAME;
BOSS_API extern const uint32_t BOSS_API_WARN_LO_MISMATCH;
BOSS_API extern const uint32_t BOSS_API_ERROR_FILE_WRITE_FAIL;
BOSS_API extern const uint32_t BOSS_API_ERROR_FILE_DELETE_FAIL;
BOSS_API extern const uint32_t BOSS_API_ERROR_FILE_NOT_UTF8;
BOSS_API extern const uint32_t BOSS_API_ERROR_FILE_NOT_FOUND;
BOSS_API extern const uint32_t BOSS_API_ERROR_MASTER_TIME_READ_FAIL;
BOSS_API extern const uint32_t BOSS_API_ERROR_MOD_TIME_READ_FAIL;
BOSS_API extern const uint32_t BOSS_API_ERROR_MOD_TIME_WRITE_FAIL;
BOSS_API extern const uint32_t BOSS_API_ERROR_PARSE_FAIL;
BOSS_API extern const uint32_t BOSS_API_ERROR_CONDITION_EVAL_FAIL;
BOSS_API extern const uint32_t BOSS_API_ERROR_NO_MEM;
BOSS_API extern const uint32_t BOSS_API_ERROR_INVALID_ARGS;
BOSS_API extern const uint32_t BOSS_API_ERROR_NETWORK_FAIL;
BOSS_API extern const uint32_t BOSS_API_ERROR_NO_INTERNET_CONNECTION;
BOSS_API extern const uint32_t BOSS_API_ERROR_NO_TAG_MAP;
BOSS_API extern const uint32_t BOSS_API_ERROR_REGEX_EVAL_FAIL;
BOSS_API extern const uint32_t BOSS_API_ERROR_PLUGINS_FULL;
BOSS_API extern const uint32_t BOSS_API_ERROR_GAME_NOT_FOUND;
BOSS_API extern const uint32_t BOSS_API_RETURN_MAX;

// The following are the mod cleanliness states that the API can return.
BOSS_API extern const uint32_t BOSS_API_CLEAN_NO;
BOSS_API extern const uint32_t BOSS_API_CLEAN_YES;
BOSS_API extern const uint32_t BOSS_API_CLEAN_UNKNOWN;

// The following are for signifying what load order method is being used:
BOSS_API extern const uint32_t BOSS_API_LOMETHOD_TIMESTAMP;
BOSS_API extern const uint32_t BOSS_API_LOMETHOD_TEXTFILE;

// The following are the games identifiers used by the API.
BOSS_API extern const uint32_t BOSS_API_GAME_OBLIVION;
BOSS_API extern const uint32_t BOSS_API_GAME_FALLOUT3;
BOSS_API extern const uint32_t BOSS_API_GAME_FALLOUTNV;
BOSS_API extern const uint32_t BOSS_API_GAME_NEHRIM;
BOSS_API extern const uint32_t BOSS_API_GAME_SKYRIM;


//////////////////////////////
// Error Handling Functions
//////////////////////////////

// Outputs a string giving the details of the last time an error or 
// warning return code was returned by a function.
BOSS_API uint32_t GetLastErrorDetails(const uint8_t ** details);


//////////////////////////////
// Version Functions
//////////////////////////////

// Returns whether this version of BOSS supports the API from the given 
// BOSS version. Abstracts BOSS API stability policy away from clients.
BOSS_API bool IsCompatibleVersion (const uint32_t bossVersionMajor, const uint32_t bossVersionMinor, const uint32_t bossVersionPatch);

// Returns the version string for this version of BOSS.
// The string exists for the lifetime of the library.
BOSS_API uint32_t GetVersionString (const uint8_t ** bossVersionStr);


////////////////////////////////////
// Lifecycle Management Functions
////////////////////////////////////

// Explicitly manage database lifetime. Allows clients to free memory when
// they want/need to. clientGame sets the game the DB is for, and dataPath
// is the path to that game's Data folder, and is case-sensitive if the
// underlying filesystem is case-sensitive. This function also checks that
// plugins.txt and loadorder.txt (if they both exist) are in sync.
BOSS_API uint32_t CreateBossDb  (boss_db * db, const uint32_t clientGame, const uint8_t * dataPath);

BOSS_API void DestroyBossDb (boss_db db);


///////////////////////////////////
// Database Loading Functions
///////////////////////////////////

// Loads the masterlist and userlist from the paths specified.
// Can be called multiple times. On error, the database is unchanged.
// Paths are case-sensitive if the underlying filesystem is case-sensitive.
// masterlistPath and userlistPath are files.
BOSS_API uint32_t Load (boss_db db, const uint8_t * masterlistPath,
									const uint8_t * userlistPath);

// Evaluates all conditional lines and regex mods the loaded masterlist. 
// This exists so that Load() doesn't need to be called whenever the mods 
// installed are changed. Evaluation does not take place unless this function 
// is called. Repeated calls re-evaluate the masterlist from scratch each time, 
// ignoring the results of any previous evaluations. Paths are case-sensitive 
// if the underlying filesystem is case-sensitive.
BOSS_API uint32_t EvalConditionals(boss_db db);


//////////////////////////////////
// Masterlist Updating
//////////////////////////////////

// Checks if there is a masterlist at masterlistPath. If not,
// it downloads the latest masterlist for the DB's game to masterlistPath.
// If there is, it first compares online and local versions to see if an
// update is necessary.
BOSS_API uint32_t UpdateMasterlist(boss_db db, const uint8_t * masterlistPath);


////////////////////////////////
// Plugin Sorting Functions
////////////////////////////////

//Returns which method BOSS is using for the load order.
BOSS_API uint32_t GetLoadOrderMethod(boss_db db, uint32_t *method);

/* Sorts the mods in the data path, using the masterlist at the masterlist path,
 specified when the db was loaded using Load. Outputs a list of plugins, pointed to
 by sortedPlugins, of length pointed to by listLength. lastRecPos points to the 
 position in the sortedPlugins list of the last plugin recognised by BOSS.
 If the trialOnly parameter is true, no plugins are actually redated.
 If trialOnly is false, then sortedPlugins, listLength and lastRecPos can be null
 pointers, in case you do not require the information. */
BOSS_API uint32_t SortMods(boss_db db, const bool trialOnly, uint8_t *** sortedPlugins, 
								size_t * listLength, 
								size_t * lastRecPos);

//Does the same thing as the above SortMods, but operates on the inputted plugin list
//instead of what's in the Data folder. NOT YET IMPLEMENTED.
BOSS_API uint32_t SortGivenMods(boss_db db, uint8_t ** pluginsIn, uint8_t *** pluginsOut, size_t * lastRecPos);

// Gets a list of plugins in load order, with the number of plugins given by numPlugins.
BOSS_API uint32_t GetLoadOrder(boss_db db, uint8_t *** plugins, size_t * numPlugins);

// Sets the load order to the given plugins list of length numPlugins.
// Then scans the Data directory and appends any other plugins not included in the
// array passed to the function.
BOSS_API uint32_t SetLoadOrder(boss_db db, uint8_t ** plugins, const size_t numPlugins);

// Returns the contents of plugins.txt.
BOSS_API uint32_t GetActivePlugins(boss_db db, uint8_t *** plugins, size_t * numPlugins);

// Edits plugins.txt so that it lists the given plugins, in load order.
BOSS_API uint32_t SetActivePlugins(boss_db db, uint8_t ** plugins, const size_t numPlugins);

// Gets the load order of the specified plugin, giving it as index. The first position 
// in the load order is 0.
BOSS_API uint32_t GetPluginLoadOrder(boss_db db, const uint8_t * plugin, size_t * index);

// Sets the load order of the specified plugin, removing it from its current position 
// if it has one. The first position in the load order is 0. If the index specified is
//greater than the number of plugins in the load order, the plugin will be inserted at
//the end of the load order.
BOSS_API uint32_t SetPluginLoadOrder(boss_db db, const uint8_t * plugin, size_t index);

// Gets what plugin is at the specified load order position. The first position in the
// load order is 0.
BOSS_API uint32_t GetIndexedPlugin(boss_db db, const size_t index, uint8_t ** plugin);

// If (active), adds the plugin to plugins.txt in its load order if it is not already present.
// If (!active), removes the plugin from plugins.txt if it is present.
BOSS_API uint32_t SetPluginActive(boss_db db, const uint8_t * plugin, const bool active);

// Checks to see if the given plugin is listed in plugins.txt.
BOSS_API uint32_t IsPluginActive(boss_db db, const uint8_t * plugin, bool * isActive);


//////////////////////////
// DB Access Functions
//////////////////////////

// Returns an array of the Bash Tags encounterred when loading the masterlist
// and userlist, and the number of tags in the returned array. The array and
// its contents are static and should not be freed by the client.
BOSS_API uint32_t GetBashTagMap (boss_db db, BashTag ** tagMap, size_t * numTags);

// Returns arrays of Bash Tag UIDs for Bash Tags suggested for addition and removal 
// by BOSS's masterlist and userlist, and the number of tags in each array.
// The returned arrays are valid until the db is destroyed or until the Load
// function is called.  The arrays should not be freed by the client. modName is 
// case-insensitive. If no Tags are found for an array, the array pointer (*tagIds)
// will be NULL. The userlistModified bool is true if the userlist contains Bash Tag 
// suggestion message additions.
BOSS_API uint32_t GetModBashTags (boss_db db, const uint8_t * plugin, 
									uint32_t ** tagIds_added, 
									size_t * numTags_added, 
									uint32_t **tagIds_removed, 
									size_t *numTags_removed,
									bool * userlistModified);
									
// Returns the message associated with a dirty mod and whether the mod needs
// cleaning. If a mod has no dirty mmessage, *message will be NULL. modName is
// case-insensitive. The return values for needsCleaning are:
//   BOSS_API_CLEAN_NO
//   BOSS_API_CLEAN_YES
//   BOSS_API_CLEAN_UNKNOWN
// The message string is valid until the db is destroyed or until a Load
// function is called. The string should not be freed by the client.
BOSS_API uint32_t GetDirtyMessage (boss_db db, const uint8_t * plugin, 
									uint8_t ** message, uint32_t * needsCleaning);
									
// Writes a minimal masterlist that only contains mods that have Bash Tag suggestions, 
// and/or dirty messages, plus the Tag suggestions and/or messages themselves. outputFile 
// is the path to use for output. If  outputFile already exists, it will only be overwritten 
// if overwrite is true.
BOSS_API uint32_t DumpMinimal (boss_db db, const uint8_t * outputFile, const bool overwrite);


#ifdef __cplusplus
}
#endif

#endif // BOSSAPI_H