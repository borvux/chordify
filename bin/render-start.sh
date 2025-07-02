#!/usr/bin/env bash
set -o errexit
bundle exec puma --port $PORT config.ru
