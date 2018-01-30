#!/bin/bash
source activate py3.6

OS=`uname`
if [ "$OS" = "Linux" ]; then
	pip install auditwheel
else
	sudo pip install delocate
fi

cd dist
FILES=`ls -1`

for FILE in ${FILES[@]};do
	if [ "$OS" = "Linux" ]; then
		auditwheel repair $FILE
	else
		delocate -v $FILE
	fi
done
