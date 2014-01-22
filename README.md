iSwipe
=============

An implementation of Swype, Android's gesture-based keyboard, for jailbroken iOS. iSwipe features word completion and intelligent word selection.

**This is a fork of wyndwarrior/iSwipe** and largely a rewrite at that.

Coming Soon
-----------
- Machine learning to make word choice better.
- Rewrite finger trail path with OpenGL
- Word list updating (If I can find a reliable REST API that offers such data that preferably supports delta updates)
- Using iOS's dictionary

Dependencies
------------

**iSwipe is built on Mac OS X using [theos](http://iphonedevwiki.net/index.php/Theos/Getting_Started)** 

**iSwipe depends on SQLite** (used for to store the dictionary)

Installation
------------

You can build it from source by cloning this repo, cd'ing into the resulting directory, and making.

    git clone git@github.com:fhsjaagshs/iSwipe.git iswipe
    cd iswipe
    export THEOS=/opt/theos # The makefile requires a this to be export'd
    make
    
Now you can find **iSwipe.dylib** in `obj/`. Copy it to `/Library/MobileSubstrate/DynamicLibraries/` on your iPhone. 

Then copy **dictionary.db** to `/usr/share/iSwipe/dictionaries.db`, making any necessary directories along the way.