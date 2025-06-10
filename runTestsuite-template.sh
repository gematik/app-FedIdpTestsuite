#!/bin/bash

export TIGER_TESTENV_CFGFILE=tiger-template.yaml

mvn verify -Dskip.unittests=true -Dcucumber.filter.tags="@Approval"
