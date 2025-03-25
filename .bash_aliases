alias python='python3'

alias grep-hist='history | grep'

alias ssh-vm='ssh $VM_USER@$VM_IP'

###### Conda aliases ######

conda_create() {
    local env_name="$1"
    # Get python version from the 2nd parameter if given
    # otherwise set it to version of local installation (python --version)
    local python_version="${2:-$(python --version 2>&1 | awk '{print $2}')}"

    conda create -n "$1" python="$2" -y
    conda activate "$1"
}

alias conda-create='conda_create'

conda_remove() {
    conda env remove -n "$1" -y
}

alias conda-remove='conda_remove'
