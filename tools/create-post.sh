#!/usr/bin/env bash
#
# Creates a new post


command="bundle exec jekyll post"

help() {
  echo "Usage:"
  echo
  echo "   bash /path/to/create-post [options]"
  echo
  echo "Options:"
  echo "     -n, --name [NAME]    Post name."
  echo "     -h, --help           Print this help information."
}

while (($#)); do
  opt="$1"
  case $opt in
  -n | --name)
    name="$2"
    shift 2
    ;;
  -h | --help)
    help
    exit 0
    ;;
  *)
    echo -e "> Unknown option: '$opt'\n"
    help
    exit 1
    ;;
  esac
done

command="$command $name"

echo -e "\n> $command\n"
eval "$command"
