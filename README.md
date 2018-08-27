# perl-ponomar-api
Ponomar: an API for liturgical computations in the Perl language

======================

Ponomar is an API for Liturgical Computing for the Byzantine Rite written in Perl.
It provides the following features:

* Computation of Pascha on the Julian, Gregorian and Milankovich calendars
* Convertion between calendars
* Computation of other Paschalion data points
* Complete listing of saints for any day of any year
* Fasting instructions for any day of any year based on the Slavonic Typicon of 1695
* Listing of Scripture readings at Vespers, Matins and Liturgy for any day of any year based on the Slavonic Lectionary
* Limited library of lives of saints, icons and other data
* Localization: English, French, Russian, Greek and Chinese are supported

This program is ALPHA-PHASE software and is thus provided with ABSOLUTELY NO WARRANTY,
not even the implied warranties of merchantability or fitness for a purpose.

The development of this program is part of the Slavonic Computing Initiative (SCI) at the 
Ponomar Project. For more information, please visit https://sci.ponomar.net/

DATA

The data are housed in a separate repository here:
https://github.com/typiconman/ponomar

This repository is cloned as a submodule in the data/ folder of this repository.
The API uses File::ShareDir to install these data into a shared folder.
There may be instances when you don't want to do this, for example, when you want to use
your own clone of the ponomar repository, which you sync nightly with GitHub.
In this case, delete the shared install and place the path to your shared directory on line 22
of lib/Ponomar/Util.pm

INSTALLATION

To install this module type the following:

   perl Makefile.PL
   make
   make test
   make install

DEPENDENCIES

This program requires Unicode support (Perl 5.8.1 or higher for sure).

DOCUMENTATION

Is available; to generate PDF documentation, type:

   make doc

(XeLaTeX is required)
or see http://www.ponomar.net/files/ponomar.pdf for documentation.
