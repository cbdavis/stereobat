# Attempts to find bat pulses in the audio vector y, by comparing against level l
#
# It does this by running a state machine over the data:
# - state 0 (idle):         wait for a signal level over l
# - state 1 (wait high):    wait while signal level l has been maintained for a least period p1
# - state 2 (high):         wait until level drops below l
# - state 3 (wait low):     wait until signal level has dropped below l for at least period p2 

function findcalls(y, l)
state = 0;
t1 = 0;
t2 = 0;
p1 = 240;
p2 = 240;
for i = 1:numel(y)
    switch (state)
    case 0
        if (y(i) >= l)
            t1 = i;
            state = 1;
        endif
    case 1
        if (y(i) < l)
            state = 0;
        endif
        if ((i - t1) > p1)
            state = 2;
        endif
    case 2
        if (y(i) < l)
            t2 = i;
            state = 3;
        endif
    case 3
        if (y(i) >= l)
            state = 2;
        endif
        if ((i - t2) > p2)
            printf("%d - %d\n", t1, t2);
            state = 0;
        endif
    endswitch
endfor
endfunction


