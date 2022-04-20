#!/bin/bash

#cats the output, searches fro PANTHER results, removes Fatty acid synthases and removes duplicate rows
cat OG_Leca45T_interpro_out.tsv | grep PANTHER | cut -f 1,4,6 | grep -v FATTY | uniq > OG_Leca45T_interpro_out_PANTHER_uniq.tsv
