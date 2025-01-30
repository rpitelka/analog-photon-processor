# Add Python 2.7! to the path. But only if we're on EL6.
if (`uname -r` =~ *el6*) then
    set path=( /tape/mitch_sim/bjr/python27/bin $path )
    if ( $?LD_LIBRARY_PATH ) then
        setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH\:/tape/mitch_sim/bjr/python27/lib/
    else
        setenv LD_LIBRARY_PATH /tape/mitch_sim/bjr/python27/lib/
    endif
endif

