IONORT - IONOsphere Ray-Tracing
===============================

Version: 0.7.2 - 15/10/2011
Website: http://roma2.rm.ingv.it/en/facilities/software/46/ionort


Overview
--------

IONORT (IONOspheric Ray Tracing) is an applicative software tool for calculating a three-dimensional ray tracing of high frequency waves in the ionospheric medium. This tool runs under Windows operating systems and its friendly graphical user interface facilitates both the numerical data input/output and the two/three-dimensional visualization of the ray path. In order to calculate the coordinates of the ray and the three components of the wave vector along the path as dependent variables, the core of the program solves a system of six first order differential equations, the group path being the independent variable of integration. IONORT uses a three-dimensional electron density specification of the ionosphere, as well as by geomagnetic field and neutral particles-electrons collision frequency models having validity in the area of interest. 


Requirements
------------

* Windows XP or above
* MathWorks MATLAB 2006 or above


Directory basic structure
-------------------------

* [root]         : GUI program and a .ini file with default input options
* [root]/bin     : binary tools, at the moment only for exporting to EPS format 
* [root]/lib     : MATLAB libraries used by the GUI program
* [root]/results : saving directory for text files created at every elaboration result
* [root]/source  : core executable programs (one per model) and Grid profiles text file

	
Basic usage
-----------

* Open Matlab program
* Change workspace to the [program]/MATLAB directory
* Launch ionort_gui.m to open the graphic user interface
* Input ray-tracing parameters
* Enable step cycles in frequency, azimuth or elevation [optional]
* Change ionospheric model in box "model" [optional]
* Click the RUN button to start the elaboration
* Output is displayed in three ways: numeric results, 2D Azimuthal plot, 3D Earth plot


Usage tips
----------

Elaborate using other grid profiles:
* Change dir to /source/GRIDPROFILES
* Select and copy a .txt file to the upper dir /source
* Rename copied file to GRIDPROFILES.txt
* Run the program

Export 2D Azimuthal plot in EPS:
* Run an elaboration and wait until it ends
* Go to window main menù "File"
* Click to "Export 2D to EPS"
* Insert a file name


Authors
-------
FORTRAN CORE: Cesidio Bianchi (cesidio.bianchi@ingv.it)
FORTRAN CORE: Alessandro Settimi (alessandro.settimi@ingv.it)
MATLAB GUI: Adriano Azzarone (adriano.azzarone@ingv.it)


License
-------

Copyright (c) 2011 Istituto Nazionale di Geofisica e Vulcanologia, 
Roma2 Department - Geomagnetism, Aeronomy and Environmental Geophysics.

This program is licensed using:
Creative Commons - Attribution-NonCommercial-NoDerivs 3.0 Unported - CC BY-NC-ND 3.0

Read the full license Legal Code at:
http://creativecommons.org/licenses/by-nc-nd/3.0/legalcode

You are free:

    to Share — to copy, distribute and transmit the work

Under the following conditions:

    Attribution — You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).

    Noncommercial — You may not use this work for commercial purposes.

    No Derivative Works — You may not alter, transform, or build upon this work.

With the understanding that:

    Waiver — Any of the above conditions can be waived if you get permission from the copyright holder.
    Public Domain — Where the work or any of its elements is in the public domain under applicable law, that status is in no way affected by the license.
    Other Rights — In no way are any of the following rights affected by the license:
        Your fair dealing or fair use rights, or other applicable copyright exceptions and limitations;
        The author's moral rights;
        Rights other persons may have either in the work itself or in how the work is used, such as publicity or privacy rights.
    Notice — For any reuse or distribution, you must make clear to others the license terms of this work. The best way to do this is with a link to this web page.
