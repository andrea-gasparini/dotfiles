alias hist-grep='history | grep'
alias grep-hist='history | grep'

alias ssh-vm="ssh $VM_USER@$VM_IP"

###### Python aliases ######

alias python='python3'
alias py='python'

py_init() {
    # Check if the project name is provided
    if [ -z "$1" ]; then
        echo "Usage: py-init <project_name> [--git-ref <branch|tag|HEAD>]"
        return 1
    fi
    
    local project_name="$1"
    local git_ref=""
    
    # Parse optional --git-ref argument
    if [ -n "$2" ] && [ "$2" = "--git-ref" ]; then
        if [ -z "$3" ]; then
            echo "Error: --git-ref requires a value (branch, tag, or HEAD)"
            return 1
        fi
        git_ref="$3"
    fi
    
    uvx copier copy --trust "gh:$GIT_CLONE_USER/py-template" "$project_name" --vcs-ref $git_ref
}

alias py-init='py_init'

py_venv() {
    # Check if a Python version is provided
    if [ -z "$1" ]; then
        python -m venv .venv
    else
        # Validate version format (e.g., 3.12, 3.11)
        if [[ "$1" =~ ^[0-9]+\.[0-9]+$ ]]; then
            # Check if the python version command exists
            if command -v "python$1" > /dev/null 2>&1; then
                python"$1" -m venv .venv
            else
                echo "Error: python$1 is not available on this system"
                return 1
            fi
        else
            echo "Error: Invalid Python version format. Use format like 3.12, 3.11, etc."
            return 1
        fi
    fi
    source .venv/bin/activate
}

alias py-venv='py_venv'

###### Git aliases ######

alias git-amend='git commit --amend'
alias git-amend-fpush='git-amend --no-edit && git push -f'

alias git-prune='git fetch --prune'

git_branch_rm() {
    local usage_msg="Usage: git-branch-rm [-D] <branch_name>"

    # Check if the branch name is provided
    if [ -z "$1" ]; then
        echo "$usage_msg"
        return 1
    fi

    local force_flag="-d"
    local branch_name=""
    
    # Parse arguments to handle -D flag in first or second position
    if [ "$1" = "-D" ]; then
        force_flag="-D"
        branch_name="$2"
        if [ -z "$branch_name" ]; then
            echo "$usage_msg"
            return 1
        fi
    elif [ "$2" = "-D" ]; then
        force_flag="-D"
        branch_name="$1"
    else
        branch_name="$1"
    fi
    
    git branch "$force_flag" "$branch_name" && git push origin --delete "$branch_name" && git fetch --prune
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
