#!/bin/bash
echo "Looking for py$1 environment"
(source activate py$1 2>/dev/null && echo "Environment found" && python setup.py bdist_wheel --plat-name $2 && source deactivate)  || (echo "Environment py$1 not found, creating" && conda create -y --name py$1 python=$1 anaconda && source activate py$1 && python setup.py bdist_wheel --plat-name $2 && source deactivate)
