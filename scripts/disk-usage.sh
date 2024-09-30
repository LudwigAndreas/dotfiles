#!/bin/bash

x=$(df -h / | awk 'FNR == 2 {printf "Root: %s available of %s",$4,$2;}')

echo "$x"
