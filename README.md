# ProcessManager
Application for Mac OS

# Archive content 
- 'Process Manager.app'

It is ready application for Mac OS, you can open it by 'ctrl' + open. This application is signed with Developer certificate, so MAC OS system will ask you to approve open application.
- 'Process Manager' folder

It contains source code of application and both xpcservice and privileged helper tool.
 
# Application Description
Process Manager is application which allows you to watch all processes currently launched on OS.
You can select to show only your launched processes, or all processes by selecting checkbox in preference settings.
Process Manager updates list of processes in real time, but refresh period is set to 2 seconds to reduce battery and processor consumption.
Additionally, it pauses if you unfocused on application.
You can select any process you like and kill it. CAUTION! Some processes can be important for stable work of Mac OS, so be careful when killing processes.
If process is launched by user - it will be killed immediately. For root processes application will ask you to install additional application privileged helper, which will do work for you.

# Limitations
This application is not tested for all kind of processes, so surely there will be some processes which are not allowed to be killed even with root privileges.


# Possible improvements
Currently application polls list of launched processes every refresh period. Perhaps, it is possible to make event driven solution by listening for changes.
Additionally, it would be great to add information bar for selected process with detailed description including work time, icon if exists e.t.c
There is also a rich field of next possibilities, which can be integrated. For example quick restart button, or observe and kill processes which are not allowed to run.
Observe potentially heavy processes which are drains battery and kill them or notify user.
Extra secure is also can be added. For example, some code sign for helper to ensure that only real application asked for privileged task.

# Used technologies
Process Manager uses sandboxed application with XPC connection to privileged helper tool. This kind of solution is the best way to divide dangerous and safe parts of code.
It uses Objective-C, C, Swift languages.

User Interface is built with both code and storyboard.

Some code is converted from UIKit which designed for iOS applications. So it just was reused without big changes.

# Build notes
If you would like to build application from source, helper tool code must be resigned with certificate. Additionally, application must be resigned too.

# Uninstall notes
Privileged Helper tool is installed with root rights. To uninstall it - remove helper '.plist' file from Library/LaunchDaemons/
And kill current launched helper tool process via Activity Monitor
