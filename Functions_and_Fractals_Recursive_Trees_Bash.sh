#!/bin/bash
#
# This script generate a Fractal Tree representation
# based on the number of iterations given by the user.
#
# Constraints:
# Rows: 63
# Columns: 100
# First branch size: 16x16
#

declare -A TREE
declare -a CENTERS
declare ROWS=63
declare COLUMNS=100
declare Y_SIZE=16
declare START_ROW=$ROWS
declare ITERATOR_CENTER=0
declare ITERATOR_NODE=0
let CENTER=$COLUMNS/2
CENTERS+=( "$CENTER" )

read input

for row in $(seq 1 $ROWS); do
    for col in $(seq 1 $COLUMNS); do
        TREE[$row,$col]="_"
    done
done

#######################################
# Find center (start point) for each 
# branch that will be initialized.
# Globals:
#   CENTERS
#   Y_SIZE
#   ITERATOR_CENTER
#   ITERATOR_NODE
# Arguments:
#   None
#######################################
findCenter () {
    for c in ${CENTERS[@]}; do
        let left=$c-$Y_SIZE
        let right=$c+$Y_SIZE
        CENTERS+=( "$left" )
        CENTERS+=( "$right" )
    done
    for s in $(seq 0 $ITERATOR_CENTER); do
        unset CENTERS[$s]
    done
    for e in ${CENTERS[@]}; do
        let ITERATOR_CENTER++
        let ITERATOR_NODE++
    done
}

#######################################
# Generate tree's branches iterating
# through each centers point.
# Globals:
#   CENTERS
#   Y_SIZE
#   ITERATOR_NODE
#   START_ROW
# Arguments:
#   None
#######################################
 buildBranch () {
    for k in $(seq 1 $Y_SIZE); do
        for c in ${CENTERS[@]}; do 
            TREE[$START_ROW,$c]="1"
        done
        let START_ROW-=1
    done
    for c in ${CENTERS[@]}; do 
        let branch_left=$c-1
        let branch_right=$c+1
        for k in $(seq 1 $Y_SIZE); do
            TREE[$START_ROW,$branch_left]="1"
            TREE[$START_ROW,$branch_right]="1"
            let branch_left-=1
            let branch_right+=1
            let START_ROW-=1
        done
        if [[ "$ITERATOR_NODE" -gt "0" ]]; then
            let START_ROW=$START_ROW+$Y_SIZE
        fi
        let ITERATOR_NODE--
    done
    findCenter
    let Y_SIZE=$Y_SIZE/2
}

for i in $(seq 1 $input); do
   buildBranch
done

for row in $(seq 1 $ROWS); do
    for col in $(seq 1 $COLUMNS); do
        echo -ne ${TREE[$row,$col]}
    done
    echo
done
echo