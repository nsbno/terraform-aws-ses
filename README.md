terraform-aws-ses
=================

A module for a standardized SES setup with best practices for e-mail!

This module is only intended to use on domains you control. Meaning your
account sets own hosted zone (i.e. trafficinfo.vydev.no). If you want to send
directly from a @vy.no e-mail address, then this is not the solution.


Running in sandbox mode
-----------------------

You may want to only run in sandbox mode if you want to only send to a selected
few recipients and send less than 200 emails per day (i.e. for reporting purposes).

There is an example of this in [examples/sandbox/](examples/sandbox/).
