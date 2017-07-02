#!/bin/bash
echo "Looking for py$1 environment"
(source activate py$1 2>/dev/null && echo "Environment found" && python setup.py bdist_wheel --plat-name $2 && source deactivate)  || (echo "Environment py$1 not found, creating" && conda create -y --name py$1 python=$1 numpy cython && source activate py$1 && python setup.py bdist_wheel --plat-name $2 && source deactivate)

pip install twine

if [ "$2" = "TMP" ]; then
	before="TMP.whl"
	after="macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64.whl"
	cd dist
	head=`ls *-TMP.whl| cut -f1-4 -d"-"`
	mv *-TMP.whl $head-$after
	cd ..
fi
