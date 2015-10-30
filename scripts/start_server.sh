#!/bin/bash
export KB_DEPLOYMENT_CONFIG=/kb/dev_container/modules/feature_sequence/deploy.cfg
export PYTHONPATH=/kb/dev_container/modules/feature_sequence/lib:$PATH:$PYTHONPATH
uwsgi --master --processes 5 --threads 5 --http :5000 --wsgi-file /kb/dev_container/modules/feature_sequence/lib/feature_sequence/feature_sequenceServer.py
