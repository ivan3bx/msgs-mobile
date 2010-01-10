Description
-----------

An basic iPhone client for 'msgs' (see http://sourceforge.net/projects/msgs/ for information on 'msgs'), over SSL.
This project may not be of much use to the majority of the known universe, but it does aim to implement the msgs protocol, and should be easily 'back-portable' for other Cocoa applications.


LIMITATIONS
-----------

Currently supports browsing only, obeying rc-read count and bounds checking.  Rendering makes its best attempt at parsing content as Markdown, and applies a minimal amount of styling in CSS.  Linking to URL's is not supported yet, as is posting of content.  Basic authentication ('logon') for now over SSL.  Credentials are not stored after each session until Keychain support is done.


Installation
------------

Edit Constants.h to set 'MSGS_SERVER_URL' to your particular server.  'Build & Run'.  The application will prompt you for a username and password, after which it will attempt to connect to the msgs server.