#!/bin/bash


workspaces delete emmanueltran && workspaces create emmanueltran
ssh workspace-emmanueltran "git clone git@github.com/Manu-Tran/my-config.git ~/my-config && ./my-config/setup-workspace.sh"
