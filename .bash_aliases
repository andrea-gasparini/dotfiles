alias python='python3'

alias grep-hist='history | grep'

alias ssh-vm='ssh $VM_USER@$VM_IP'

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
