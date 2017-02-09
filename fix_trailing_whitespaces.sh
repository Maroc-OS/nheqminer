#!/bin/sh

git ls-files -z -- \
 bootstrap doxygen.config '*.readme' \
 '*.c' '*.cmake' '*.cpp' '*.cxx' \
 '*.el' '*.f' '*.f90' '*.h' '*.in' '*.in.l' '*.java' \
 '*.mm' '*.pike' '*.py' '*.txt' '*.vim' |
egrep -z -v '^(Utilities/cm|Source/(kwsys|CursesDialog/form)/)' |
egrep -z -v '^(Modules/CPack\..*\.in)' |
xargs -0 sed -i 's/ \+$//'

