#!/bin/bash
export PYTHONPATH=/kb/dev_container/modules/feature_sequence/lib:$PATH:$PYTHONPATH
python /kb/dev_container/modules/feature_sequence/lib/feature_sequence/feature_sequenceServer.py $1 $2 $3
