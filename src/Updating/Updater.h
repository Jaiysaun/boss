/*	BOSS

	A "one-click" program for users that quickly optimises and avoids
	detrimental conflicts in their TES IV: Oblivion, Nehrim - At Fate's Edge,
	TES V: Skyrim, Fallout 3 and Fallout: New Vegas mod load orders.

	Copyright (C) 2009-2012    BOSS Development Team.

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

	$Revision: 3184 $, $Date: 2011-08-26 20:52:13 +0100 (Fri, 26 Aug 2011) $
*/

#ifndef UPDATING_UPDATER_H_
#define UPDATING_UPDATER_H_

#include <fstream>
#include <string>
#include <vector>

#include <git2.h>

#include "Common/Game.h"
#include "Support/Logger.h"

namespace boss {

struct pointers_struct {
	pointers_struct()
	    : repo(NULL),
	      remote(NULL),
	      cfg(NULL),
	      obj(NULL),
	      commit(NULL),
	      ref(NULL),
	      sig(NULL),
	      blob(NULL) {}

	void free() {
		git_commit_free(commit);
		git_object_free(obj);
		git_config_free(cfg);
		git_remote_free(remote);
		git_repository_free(repo);
		git_reference_free(ref);
		git_signature_free(sig);
		git_blob_free(blob);
	}

	git_repository * repo;
	git_remote * remote;
	git_config * cfg;
	git_object * obj;
	git_commit * commit;
	git_reference * ref;
	git_signature * sig;
	git_blob * blob;
};

inline void handle_error(int error_code, pointers_struct& pointers) {
	if (!error_code)
		return;

	const git_error * error = giterr_last();
	std::string error_message;
	if (error == NULL)
		error_message = IntToString(error_code) + ".";
	else
		error_message = IntToString(error_code) + "; " + error->message;
	pointers.free();
	giterr_clear();

	LOG_ERROR("Git operation failed. Error: %s", error_message.c_str());
	throw boss_error(error_message, BOSS_ERROR_GIT_ERROR);
}

inline std::string RepoURL(const Game& game) {
	// TODO(MCP): Look at converting this to a switch-statement
	if (game.Id() == OBLIVION)
		return gl_oblivion_repo_url;
	else if (game.Id() == NEHRIM)
		return gl_nehrim_repo_url;
	else if (game.Id() == SKYRIM)
		return gl_skyrim_repo_url;
	else if (game.Id() == FALLOUT3)
		return gl_fallout3_repo_url;
	else
		return gl_falloutnv_repo_url;
}

inline bool are_files_equal(const void * buf1, size_t buf1_size,
                            const void * buf2, size_t buf2_size) {
	if (buf1_size != buf2_size)
		return false;

	size_t pos = 0;
	while (pos < buf1_size) {
		if (*((char*)buf1 + pos) != *((char*)buf2 + pos))
			return false;
		++pos;
	}
	return true;
}

// Gets the revision SHA (first 9 characters) for the currently checked-out masterlist, or "unknown".
inline std::string GetMasterlistVersion(Game& game) {
	if (!fs::exists(game.Masterlist().parent_path() / ".git" / "HEAD")) {
		return "Unknown: Git repository missing";
	} else {
		std::string rev;
		// Naive check, ignoring working directory changes.

		/*
		 * Better check, which compares HEAD to the working dir.
		 * 
		 * 1. Get an object for the masterlist in HEAD.
		 * 2. Get the blob for that object.
		 * 3. Open the masterlist file in the working dir in a file buffer.
		 * 4. Compare the file and blob buffers.
		 */
		pointers_struct ptrs;
		LOG_INFO("Existing repository found, attempting to open it.");
		handle_error(git_repository_open(&ptrs.repo, game.Masterlist().parent_path().string().c_str()), ptrs);

		LOG_INFO("Getting HEAD masterlist object.");
		handle_error(git_revparse_single(&ptrs.obj, ptrs.repo, "HEAD:masterlist.txt"), ptrs);

		LOG_INFO("Getting blob for masterlist object.");
		handle_error(git_blob_lookup(&ptrs.blob, ptrs.repo, git_object_id(ptrs.obj)), ptrs);

		LOG_INFO("Opening masterlist in working directory.");
		std::string mlist;
		fileToBuffer(game.Masterlist(), mlist);

		LOG_INFO("Comparing files.");
		if (are_files_equal(git_blob_rawcontent(ptrs.blob), git_blob_rawsize(ptrs.blob), mlist.data(), mlist.length())) {
			ptrs.free();
			// For some reason trying to get the revision of HEAD:masterlist.txt using libgit2 gives me 18efbc9d8 instead.
			std::string revision;
			ifstream head((game.Masterlist().parent_path() / ".git" / "HEAD").string());
			head >> revision;
			head.close();
			revision.resize(9);
			return revision;
		} else {
			ptrs.free();
			return "Unknown: Masterlist edited";
		}
	}
}

// Progress has form prog(const char *str, int len, void *data)
template<class Progress>
std::string UpdateMasterlist(Game& game, Progress prog, void * out) {
	pointers_struct ptrs;
	const git_transfer_progress * stats = NULL;

	LOG_INFO("Checking for a Git repository.");

	// Checking for a ".git" folder.
	if (fs::exists(game.Masterlist().parent_path() / ".git")) {
		// Repository exists. Open it.
		LOG_INFO("Existing repository found, attempting to open it.");
		handle_error(git_repository_open(&ptrs.repo, game.Masterlist().parent_path().string().c_str()), ptrs);

		LOG_INFO("Attempting to get info on the repository remote.");

		// Now get remote info.
		handle_error(git_remote_load(&ptrs.remote, ptrs.repo, "origin"), ptrs);

		LOG_INFO("Getting the remote URL.");

		// Get the remote URL.
		const char * url = git_remote_url(ptrs.remote);

		LOG_INFO("Checking to see if remote URL matches URL in settings.");

		// Check if the repo URLs match.
		LOG_INFO("Remote URL given: %s", RepoURL(game).c_str());
		LOG_INFO("Remote URL in repository settings: %s", url);
		if (url != RepoURL(game)) {
			LOG_INFO("URLs do not match, setting repository URL to URL in settings.");
			// The URLs don't match. Change the remote URL to match the one BOSS has.
			handle_error(git_remote_set_url(ptrs.remote, RepoURL(game).c_str()), ptrs);

			// Now save change.
			handle_error(git_remote_save(ptrs.remote), ptrs);
		}
	} else {
		LOG_INFO("Repository doesn't exist, initialising a new repository.");
		// Repository doesn't exist. Set up a repository.
		handle_error(git_repository_init(&ptrs.repo, game.Masterlist().parent_path().string().c_str(), false), ptrs);

		LOG_INFO("Setting the new repository's remote to: %s", RepoURL(game).c_str());

		// Now set the repository's remote.
		handle_error(git_remote_create(&ptrs.remote, ptrs.repo, "origin", RepoURL(game).c_str()), ptrs);
	}

	// WARNING: This is generally a very bad idea, since it makes HTTPS a little bit pointless, but in this case because we're only reading data and not really concerned about its integrity, it's acceptable. A better solution would be to figure out why GitHub's certificate appears to be invalid to OpenSSL.
#ifndef _MSC_VER
	git_remote_check_cert(ptrs.remote, 0);
#endif

	LOG_INFO("Fetching updates from remote.");

	// Now pull from the remote repository. This involves a fetch followed by a merge. First perform the fetch.

	// Set up callbacks.
	git_remote_callbacks callbacks = GIT_REMOTE_CALLBACKS_INIT;
	callbacks.transfer_progress = prog;
	callbacks.payload = out;
	git_remote_set_callbacks(ptrs.remote, &callbacks);

	// Fetch from remote.
	LOG_INFO("Fetching from remote.");
	handle_error(git_remote_fetch(ptrs.remote), ptrs);

	/*
	 * Now start the merging. Not entirely sure what's going on here, but it looks like libgit2's merge API is incomplete, you can create some git_merge_head objects, but can't do anything with them...
	 * Thankfully, we don't really need a merge, we just need to replace whatever's in the working directory with the relevant file from FETCH_HEAD, which was updated in the fetching step before.
	 * The porcelain equivalent is `git checkout refs/remotes/origin/gh-pages masterlist.txt`
	 */

	LOG_INFO("Setting up checkout parameters.");

	char * paths[] = {"masterlist.txt"};

	git_checkout_opts opts = GIT_CHECKOUT_OPTS_INIT;
	opts.checkout_strategy = GIT_CHECKOUT_FORCE;  // Make sure the existing file gets overwritten.
	opts.paths.strings = paths;
	opts.paths.count = 1;

	// Next, we need to do a looping checkout / parsing check / roll-back.
	/*
	 * Here's what to do:
	 * 
	 * 0. Create a git_signature using git_signature_default.
	 * 1. Get the git_object for the desired masterlist revision, using git_revparse_single.
	 * 2. Get the git_oid for that object, using git_object_id.
	 * 3. Get the git_reference for the HEAD reference using git_reference_lookup.
	 * 5. Generate a short string for the git_oid, to display in the log.
	 * 6. (Re)create a HEAD reference to point directly to the desired masterlist revision,
	 *    using its git_oid and git_reference_create.
	 * 7. Perform the checkout of HEAD.
	 */

	// Apparently I'm using libgit2's head, not v0.20.0, so I don't need this...
	//LOG_INFO("Creating a Git signature.");
	//handle_error(git_signature_default(&ptrs.sig, ptrs.repo), ptrs);

	char revision[10];
	string filespec = "refs/remotes/origin/master~0";
	LOG_INFO("Getting the Git object for the tree at refs/remotes/origin/master~0.");
	handle_error(git_revparse_single(&ptrs.obj, ptrs.repo, filespec.c_str()), ptrs);

	LOG_INFO("Getting the Git object ID.");
	const git_oid * oid = git_object_id(ptrs.obj);

	LOG_INFO("Generating hex string for Git object ID.");
	git_oid_tostr(revision, 10, oid);

	LOG_INFO("Recreating HEAD as a direct reference (overwriting it) to the desired revision.");
	handle_error(git_reference_create(&ptrs.ref, ptrs.repo, "HEAD", oid, 1), ptrs);

	LOG_INFO("Performing a Git checkout of HEAD.");
	handle_error(git_checkout_head(ptrs.repo, &opts), ptrs);

	LOG_INFO("Tree hash is: %s", revision);
	LOG_INFO("Freeing pointers.");
	ptrs.free();

	return string(revision);
}

}  // namespace boss
#endif  // UPDATING_UPDATER_H_
