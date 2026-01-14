#!/bin/bash

clone_repo() {
    local repo_url="$1"
    local repo_name=$(basename "$repo_url" .git)
    
    if [ -d "$repo_name" ]; then
        echo "Repository $repo_name already exists, skipping."
    else
        git clone "$repo_url"
    fi
}

clone_repos() {
    # Define root directory for projects
    local ROOT_DIR="$HOME/dev/"

    # Two Point One repos
    if [ -d "$ROOT_DIR/two-point-one" ]; then
        cd "$ROOT_DIR/two-point-one"
        clone_repo git@github.com:two-point-one-analytics/gtm-dev-site.git
        clone_repo git@github.com:two-point-one-analytics/journa-dw.git
        clone_repo git@github.com:two-point-one-analytics/ripe-dw.git
        clone_repo git@github.com:two-point-one-analytics/etl.git
    else
        echo "Directory $ROOT_DIR/two-point-one does not exist, skipping clones."
    fi

    # Datm repos
    if [ -d "$ROOT_DIR/datm" ]; then
        cd "$ROOT_DIR/datm"
        clone_repo git@github.com:datm-cc/web.git
        clone_repo git@github.com:datm-cc/code.git
        clone_repo git@github.com:datm-cc/etl.git
        clone_repo git@github.com:datm-cc/site.git
    else
        echo "Directory $ROOT_DIR/datm does not exist, skipping clones."
    fi

    # Curtis repos
    if [ -d "$ROOT_DIR/curtis" ]; then
        cd "$ROOT_DIR/curtis"
        clone_repo git@github.com:curtis2point1/ai-stack.git
        clone_repo git@github.com:curtis2point1/ai-ops.git
    else
        echo "Directory $ROOT_DIR/curtis does not exist, skipping clones."
    fi
}

# Execute the function
clone_repos
