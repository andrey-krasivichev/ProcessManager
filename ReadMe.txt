!!! Provide the deliverable packaged in a compressed archive. Please, include a README and other documentation you feel necessary in order to build and run the app. In the README or source code, please describe any possible limitations of the application and outline potential improvements you would make. You can also include justification of the main design decisions you have made and discuss specific implementation details that are worth highlighting. !!!

* Archive content *
- Process Manager.app
 It is ready application for Mac OS, you can open it by 'ctrl' + open. This application is signed with Developer certificate, so MAC OS system will ask you to approve open application.
- Process Manager folder
 It contains source code of application and both xpcservice and privileged helper tool
 

* Application Description *
Process Manager is application which allows you to watch all processes currently launched.
You can select to show only your launched processes, or all processes by selecting checkbox in preference settings.
Process Manager updates list of processes in real time, but refresh period is set to 2 seconds to reduce battery and processor consumption.
Additionally, it pauses if you unfocused on application.
You can select any process you like and kill it. CAUTION! Some processes can be important for stable work of Mac OS, so be careful by killing processes.
If process is launched by user - it will be killed immediately. For root processes application will ask you to install additional application privileged helper, which will do work for you.

* Limitations *
This application is not tested for all kind of processes, so surely there will be some processes which are not allowed for kill even with root privileges.
Also,

* Possible improvements *
Currently application polls list of launched processes every refresh period. Perhaps, it is possible to make event driven solution by listening for changes.
Additionally, it would be great to add information bar for selected process with detailed description including work time, icon if exists e.t.c
There are also a rich field of next possibilities< which can be integrated. For example quick restart button, or observe and kill processes which are not allowed (just set).
 Observe potentially heavy processes which are drains battery and kill them or notify user.
Extra secure is also can be added. For example, some code sign for helper to ensure that only real application asked for privileged task.

* Used technologies *
Process Manager uses sandboxed application with XPC connection to privileged helper tool. This kind of solution is the best way to divide dangerous and safe peace of code.
It uses both Obj-C, C, swift languages
User Interface is built with both code and storyboard
Some code is converted from UIKit which designed for iOS applications. So it just was reused without big changes.
