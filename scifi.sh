#!/usr/bin/env bash

################################################################################
# scifi: instantiates my research project template
#
# Author:  Dudu Meireles
# License: GPL3
################################################################################


function scifi(){

	############################################################################
	# Functions
	############################################################################

	function echoerr() {
		printf "%s\n" "$*" >&2;
	}

	function currentdirname() {
		echo "$(basename "$PWD")";
	}

	__usage(){
		echoerr "usage: scifi -n <dir name> [(-u <remote user> -r <'bitbucket'|'github'>)] [-a <'private'|'public'>] [-p] [-h]"
	}

	__help(){
		__usage;
		echoerr "  -n <string> name for local directory where to create the research project"
		echoerr "  -u <string> username in remote host"
		echoerr "  -r <string> remote host service: <'bitbucket'|'github'>"
		echoerr "  -a <string> access type for remote <'private'|'public'>"
		echoerr "  -h          help"
		echoerr "  -p          push local repo to remote"
		echoerr ""
		echoerr "Ex1: To instantiate only local repo with the default template"
		echoerr "  scifi -n <dir name>"
		echoerr "Ex2: To create local repo and a remote in host"
		echoerr "  scifi -n <dir name> -u <username remote>";
	}

	############################################################################
	# Variables
	############################################################################

	local __paper_url="https://github.com/meireles/paper_template"
	local __proj_url="https://github.com/meireles/research_project_template"

	local __branch="master"       ## hardcoded for now

	local __create_remote=false   ## set to true if -d or -r are specified
	local __help=false
	local __exec=true

	# user input
	local __dir=""
	local __usr=""
	local __host=""
	local __push=false
	local __accs="private"

	############################################################################
	# Get Arguments
	############################################################################

	local OPTIND=0

	while getopts "n:u:r:a:ph" args; do
		case "${args}" in
			n)
				__dir="${OPTARG}";
				;;
			u)
				__usr="${OPTARG}";
				__create_remote=true;
				;;
			r)
    	    	[[ ( "${OPTARG}" == "bitbucket" || "${OPTARG}" == "github" ) ]]  && __host="${OPTARG}" || __usage
				__create_remote=true;
				;;
			a)
    	    	[[ ( "${OPTARG}" == "private" || "${OPTARG}" == "public" ) ]]  && __accs="${OPTARG}" || __usage
				__create_remote=true;
				;;
			p)
				__push=true;
				__create_remote=true;
				;;
			h)
				__help=true;
				;;
			\?)
				echo "Unknown option: -${OPTARG}" >&2;
				return 1;
				;;
			:)
				echo "Missing argument for -${OPTARG}" >&2;
				return 1;
				;;
			*)
				echo "Unimplemented option: -${OPTARG}" >&2;
				return 1;
				;;
		esac
	done

	echo "$__dir"
	echo "$__usr"

	########################################
	# Test arguments
	########################################

	if [[ "$__help" == true ]]; then
		__exec=false;
		__help;
	else
		if [[ -z "$__dir" ]]; then
		  	__exec=false;
			echoerr "[-n <dir name>] must be provided";
		  	__usage;
			return 1;
		elif [[ (-z "$__host" || -z "$__usr" || -z "$__accs") && "$__create_remote" == true ]]; then
			__exec=false;
			echo "[-u <user>] and [-r <host>] must be provided";
			usage;
			return 1;
		fi
	fi

	################################################################################
	# Execute
	################################################################################

	if [[ "$__exec" == true ]]; then

		# Poach the template and move into the repo
		# the -b and -o params are not useful here since __branch is hardcoded. they're
		# a good reminder if that changes though.
		git_poach -t "$__proj_url" -n "$__dir" -b "$__branch" -o
		cd "$__dir"

		# Clone the manuscript template and remove the .git
		git clone "$__paper_url" manuscript
		rm -rf manuscript/.git

		# Update files, readme, etc
		./init-project

		# Squash all commits
		git_squash_commits "Instantiated from $__proj_url"

		if [[ "$__create_remote" = true ]]; then

			git_mkremote -n "$__dir" -u "$__usr" -r "$__host" -a "$__accs"

			git remote add origin "$git_mkremote_push_url"           ## set by make remote

			if [[ "$__push" == true ]]; then
				## master is hardcoded. may be trouble if I forget the -o flag for git_poach
				git push -u origin master
			fi
		fi
	fi
}
