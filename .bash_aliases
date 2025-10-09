alias python='python3'

alias hist-grep='history | grep'
alias grep-hist='history | grep'

alias ssh-vm='ssh $VM_USER@$VM_IP'

###### Git aliases ######

alias git-amend='git commit --amend'
alias git-amend-fpush='git-amend --no-edit && git push -f'

git_branch_rm() {
    # Check if the branch name is provided
    if [ -z "$1" ]; then
        echo "Usage: git-branch-rm <branch_name>"
        return 1
    fi
    git branch -d "$1" && git push origin --delete "$1" && git fetch --prune
}

alias git-branch-rm='git_branch_rm'

git_undo() {
    # Defaults to undoing the last commit if no argument is provided
    # otherwise undoes last N commits
    local count="${1:-1}"
    git reset --soft HEAD~"$count"
}

alias git-undo='git_undo'

git_rebase() {
    # Check if an argument is provided
    if [ -z "$1" ]; then
        echo "Usage: git-rebase <commit_id|number>"
        return 1
    fi
    
    # If the argument is a number
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        # Rebase (interactively) last N commits as "HEAD~$N"
        git rebase -i HEAD~"$1"
    else
        # Otherwise assume is a commit ID
        # and rebase commits until that one as "$commit_id^"
        git rebase -i "$1"^
    fi
}

alias git-rebase='git_rebase'

git_clone() {
    # Check if the repository name is provided
    if [ -z "$1" ]; then
        echo "Usage: git-clone <repo_name>"
        return 1
    fi
    git clone "git@github.com:$GIT_CLONE_USER/$1.git"
}

alias git-clone='git_clone'

###### Conda aliases ######

conda_create() {
    # Check if the environment name is provided
    if [ -z "$1" ]; then
        echo "Usage: conda-create <env_name> [python_version]"
        return 1
    fi
    # Check if the environment name is already in use
    if conda env list | grep -q "$1"; then
        echo "Environment '$1' already exists. Please choose a different name."
        return 1
    fi
    local env_name="$1"
    # Get python version from the 2nd parameter if given
    # otherwise set it to version of local installation (python --version)
    local python_version="${2:-$(python --version 2>&1 | awk '{print $2}')}"

    conda create -n "$1" python="$2" -y
    conda activate "$1"
}

alias conda-create='conda_create'

conda_remove() {
    # Check if the environment name is provided
    if [ -z "$1" ]; then
        echo "Usage: conda-remove <env_name>"
        return 1
    fi
    # Deactivate the provided environment if it's active
    if [[ "$CONDA_DEFAULT_ENV" == "$1" ]]; then
        conda deactivate
    fi
    conda env remove -n "$1" -y
}

alias conda-remove='conda_remove'
