#!/bin/bash

clone_repos() {
    # Define root directory for projects
    local ROOT_DIR="$HOME/dev/"

    # Two Point One repos
    if [ -d "$ROOT_DIR/two-point-one" ]; then
        cd "$ROOT_DIR/two-point-one"
        git clone git@github.com:two-point-one-analytics/gtm-dev-site.git || true
        git clone git@github.com:two-point-one-analytics/journa-dw.git || true
        git clone git@github.com:two-point-one-analytics/ripe-dw.git || true
        git clone git@github.com:two-point-one-analytics/etl.git || true
    else
        echo "Directory $ROOT_DIR/two-point-one does not exist, skipping clones."
    fi

    # Datm repos
    if [ -d "$ROOT_DIR/datm" ]; then
        cd "$ROOT_DIR/datm"
        git clone git@github.com:datm-cc/web.git || true
        git clone git@github.com:datm-cc/code.git || true
        git clone git@github.com:datm-cc/etl.git || true
        git clone git@github.com:datm-cc/site.git || true
    else
        echo "Directory $ROOT_DIR/datm does not exist, skipping clones."
    fi

    # Curtis repos
    if [ -d "$ROOT_DIR/curtis" ]; then
        cd "$ROOT_DIR/curtis"
        git clone git@github.com:curtis2point1/ai-stack.git || true
    else
        echo "Directory $ROOT_DIR/curtis does not exist, skipping clones."
    fi
}

# Execute the function
clone_repos

# Ripe repos

