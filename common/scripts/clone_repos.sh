#!/bin/bash

cd $HOME/projects/two-point-one
git clone git@github.com:two-point-one-analytics/gtm-dev-site.git || true
git clone git@github.com:two-point-one-analytics/journa-dw.git || true
git clone git@github.com:two-point-one-analytics/ripe-dw.git || true
git clone git@github.com:two-point-one-analytics/etl.git || true

cd $HOME/projects/datm
git clone git@github.com:datm-cc/web.git || true
git clone git@github.com:datm-cc/code.git || true
git clone git@github.com:datm-cc/etl.git || true
git clone git@github.com:datm-cc/site.git || true

# cd $HOME/projects/curtis

# cd $HOME/projects/ripe

