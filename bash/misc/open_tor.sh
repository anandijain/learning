#!/bin/bash

sh -c '"/home/sippycups/Downloads/Applications/tor-browser_en-US/Browser/start-tor-browser" --detach || ([ !  -x "/home/sippycups/Downloads/Applications/tor-browser_en-US/Browser/start-tor-browser" ] && "$(dirname "$*")"/Browser/start-tor-browser --detach)' dummy %k


