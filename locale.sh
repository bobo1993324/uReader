#!/bin/bash
xgettext -C --qt --keyword=tr --from-code=UTF-8 -p locale -o message.pot uReader.qml ui/* components/*
if [ -e "locale/zh_CN.po" ]
then
	msgmerge -N locale/zh_CN.po locale/message.pot > locale/new.po
	mv locale/new.po locale/zh_CN.po
else
	msginit -i locale/message.pot -o locale/zh_CN.po
fi
