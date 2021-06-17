Running in sandbox mode
=======================

Sandbox mode is the default state of any SES deployment. In this mode you can
only send to and from _verified_ e-mails. The sender domain is already verified
by the module, but you'll have to semi-automatically verify the recipients e-mail.

Do not use sandbox mode if you intend to send e-mails outside the organization.
