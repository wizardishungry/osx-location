Using CoreLocation on Mac OS X with command-line
================================================

    $ make
    $ ./location  --help
    --count <number>         Wait for this many responses (default: 1).
    --help                   Show this help.
		$ ./location --debug 
		location service enabled
		<+40.696969,-73.420420> +/- 65.00m (speed -1.00 mps / course -1.00) @ 6/18/13 8:43:43 PM Eastern Daylight Time
		timestamp: 2013-06-19 00:43:43 +0000
		latitude,longitude: 40.696969,-73.420420
		altitude: 26.000000
		horizontalAccuracy: 65.000000
		verticalAccuracy: 10.000000
		speed: -1.000000
		course: -1.000000
Credits
-------
Originally by moo@tmiz.net - https://gist.github.com/tmiz/1416248
