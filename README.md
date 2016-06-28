# scifi
Dumb scientists need as much head start they can get.

author:  meireles@umn.edu
license: GPL3

## Install

clone [scifi](https://github.com/meireles/scifi) to a local dir and source `scifi.sh` in your bash rc or profile.

### Dependencies

code-wise: [git-utils](https://github.com/meireles/git-utils) and [git-subrepo](https://github.com/ingydotnet/git-subrepo/tree/issue/142) (branch `issue/142`, **not** `master`).

template-wise: [paper\_template](https://github.com/meireles/paper_template) (with [bibtexlib](https://github.com/meireles/bibtexlib) inside) and [research\_project\_template](https://github.com/meireles/research_project_template).

## Usage

see `scifi -h`. 

    $scifi -h

    usage: scifi -n <dir name> [(-u <remote user> -r <'bitbucket'|'github'>)] [-a <'private'|'public'>] [-p] [-h]
      -n <string> name for local directory where to create the research project
      -u <string> username in remote host
      -r <string> remote host service: <'bitbucket'|'github'>
      -a <string> access type for remote <'private'|'public'>
      -h          help
      -p          push local repo to remote

    Ex1: To instantiate only local repo with the default template
      scifi -n <dir name>
    Ex2: To create local repo and a remote in host
      scifi -n <dir name> -u <username remote>

