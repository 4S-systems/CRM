#!/bin/bash
clear
echo "delete xml/xfile.jar"
rm xfile.jar
echo "delete ../WEB-INF/lib/xfile.jar"
rm ../WEB-INF/lib/xfile.jar
echo "build xml/xfile.jar"
jar -cfv xfile.jar *
echo "copy xfile.jar to ../WEB-INF/lib/"
cp xfile.jar ../WEB-INF/lib/
echo "it's ok"
