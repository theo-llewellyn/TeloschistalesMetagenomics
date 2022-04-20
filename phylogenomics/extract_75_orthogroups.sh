#!/bin/bash

mkdir Single_Copy_Orthologues_75percent

cat Orthologues_Leca45T_75p.txt | while read line; do cp Orthogroup_Sequences/${line}.fa Single_Copy_Orthologues_75percent; done

