#!/bin/bash

#cd $srcdir/examples/perc
cd examples/perc

echo
echo 'Testing directory is ./examples/perc'

# Test mod
echo
echo Testing mod on perc.model
rm model.c &> /dev/null
../../mod/mod perc.model &> /dev/null

if test -f 'model.c';
 then TEST1=0; echo '-PASSED- model.c file created'
 else TEST1=1; echo '-FAILED- model.c file not created'
fi;

# Test mcsim
echo
echo Testing makemcsim on perc.model
echo Compiling mcsim.perc...
TEST2=0
(gcc -o mcsim.perc -I../../sim -I../.. -I/usr/local/include -L../../sim -L/usr/local/lib model.c ../../sim/*.c -lsbml -lm -lgsl -lgslcblas ) || TEST2=1
if test $TEST2 -eq 1;
 then echo '-FAILED-'
 else echo '-PASSED-'
fi;

# perc.lsodes.in    
echo
echo Testing Lsodes with perc.lsodes.in ...
TEST3=0
(./mcsim.perc perc.lsodes.in sim.out &> mcsim.log) || TEST3=1
if test $TEST3 -eq 1;
 then echo '-FAILED-'
 else echo '-PASSED-'
fi;

echo
echo 'Check that file examples/perc/sim.out contains reasonable output (compare to perc.lsodes.out, small rounding errors can be ignored)'
echo

TEST=0
if test $TEST1 -eq 1 -o $TEST2 -eq 1 -o $TEST3 -eq 1;
 then TEST=1;
 else TEST=0;
fi;

exit $TEST
