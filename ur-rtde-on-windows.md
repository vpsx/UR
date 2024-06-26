*I am not at all familiar with Windows, building C++ projects, or using any kind of IDE; if something looks wrong or needlessly roundabout, it probably is. Please write me/open an issue/PR!*

# Setting up UR RTDE on Windows

This doc is just an extremely verbose version of [the official UR RTDE Windows installation guide](https://sdurobotics.gitlab.io/ur_rtde/installation/installation.html#windows),
geared towards users whose Windows computers were not already otherwise set up for C++ and/or general development.
If you are using Linux or macOS, OR if you only want to use Python, then this doc is not for you; your life can be much easier; just follow the official install docs.
Otherwise, if you are stuck with Windows and you want to use Matlab or C++:

#### Install Visual Studio

First we need to install Microsoft Visual Studio (which is not the same thing as VSCode).
Go to https://visualstudio.microsoft.com/downloads/ , download the Community version, and run the installer.

> Aside: It seems absurd to me that Visual Studio is required, but:
> 1. The ur_rtde Windows install instructions give you 2 options: a Visual Studio route, or a command line route;
> 1. Obviously you need Visual Studio for the Visual Studio route. But even for the command line route, the last step uses the msbuild tool.
>    And [to build/install msbuild on Windows...... you need Visual Studio](https://github.com/dotnet/msbuild?tab=readme-ov-file#building-msbuild-with-visual-studio-2022-on-windows),
>    at least for "the full supported experience".
>
> Upd: [This page](https://learn.microsoft.com/en-us/visualstudio/msbuild/msbuild?view=vs-2022) has instructions on installing just msbuild by downloading **Build Tools for Visual Studio**; I have not tried this.

#### Install CMake

Go to https://cmake.org/download/ and run the Windows installer.

#### Install Boost

ur_rtde is built on top of Boost, so we need to install Boost.

Go to https://sourceforge.net/projects/boost/files/boost-binaries/, pick a Boost version (click into one of the folders), and pick an MSVC version (click one of the .exe files).
(I picked `boost_1_82_0-msvc-14.3-64.exe` based on the current Boost Windows documentation and on a version of msvc I installed from the Visual Studio Installer; I suspect any of the recent versions are fine.)

Run the installer. It will ask you where you want to install, and it will give a default location, probably `C:\local\boost_1_82_0`. Wherever you pick, note the location for later!

#### Clone the ur_rtde repository

Then we need to clone the ur_rtde repository itself, so that we can build and install the ur_rtde code.
1. Download Git. https://www.git-scm.com/download/win
1. You should now have an application called Git Bash. On Git Bash, navigate to wherever you want to put the ur_rtde source code.
   - `pwd` to see where you are (print working directory), `ls` to list directory contents, `cd <directory>` to change directories, `cd ..` to go back up a directory.
   - I recommend using the desktop shortcut to open Git Bash, if it created a desktop shortcut, because otherwise it seems to start you at your system root directory.
   - If you are lost, `cd c/Users/YourUsername/Desktop` should take you to your Desktop folder.
1. Clone the repository: `git clone https://gitlab.com/sdurobotics/ur_rtde.git`
1. Navigate to the newly cloned repository: `cd ur_rtde`
1. If you want to use the Python bindings, then this is where you also grab the pybind11 code: `git submodule update --init --recursive`

#### Set up Python environment

(Skip this if you don't intend to use Python.)

While we're here in the ur_rtde repo, might as well set up the Python library needed to call the bindings. (Run `pwd` and check that you are, in fact, still in the ur_rtde repo.)

As a good Python citizen, I'm supposed to tell you to first set up a virtual env:  `python -m venv venv`  (this might take a few seconds).

(You can also create a virtual env from Visual Studio or your favorite IDE. For more info on virtual envs, see https://docs.python.org/3/tutorial/venv.html)

Activate the virtual env:  `source venv/Scripts/activate`

Finally, install the ur_rtde Python library: `pip install ur_rtde`

#### Finally, build the ur_rtde code

1. Open Visual Studio and open the ur_rtde repository you just cloned, as a CMake project (see the screenshot here https://sdurobotics.gitlab.io/ur_rtde/installation/installation.html#visual-studio-build).
    - You may need to open the folder, click on the `CMakeLists.txt` file specifically, and _then_ open it.
1. From the top menu, go to "Project > CMake Settings for ur_rtde" and scroll down to "CMake command arguments"; enter
 `-DBOOST_ROOT="C:\local\boost_1_82_0" -DBOOST_LIBRARYDIR="C:\local\boost_1_82_0\lib64-msvc-14.3"` , unless you installed Boost somewhere else earlier, in which case change the paths accordingly.
  This is telling Visual Studio where your Boost installation is.
  (Note that I left out the `-DPYTHON_BINDINGS:BOOL=OFF` mentioned in the docs, since I assume you only add this if you don't intend to use Python.)
1. From the top menu, click "Build" and then "Build All". It should start generating a lot of text output in the bottom panel.
   If all goes well, there should be no ERROR messages and the output should end with "CMake generation finished".

At this point you should be able to test the installation. Below are instructions for testing the installation with Python. For C++ or Matlab, see the official docs.

#### Python: Test the import

If you have a usual Python workflow, work according to that, and do `import rtde_control`. Otherwise:

1. Open/go back to Visual Studio, and (inside Visual Studio) open/go back to the ur_rtde folder.
1. Visual Studio might show you a yellow warning banner about 'trusting the binaries in this workspace'; if so, you have to click one of the 'trust' options in order to see your virtual environment listed.
1. On the top menu click Tools > Python > Python Environments
1. In the sidebar on the right, click on "venv", the virtual environment you created earlier; if you skipped that step, there should be one default Python environment; click that instead.
1. In the submenu that appears, click Open interactive window. You should get a Python REPL/interactive window in the main box to the left.
1. In the REPL, run `import rtde_control`. If this runs without errors, then the library is working!

#### Python: Test the connection

Test that you can actually establish a connection with the UR.

1. Either connect the UR to your computer using an Ethernet cable, or make sure you are on the same wifi subnet as the UR.
   *(NB @MBL: At time of writing, the router attached to the 312 arm does **not** have wifi enabled.)*
1. You can find out the UR's IP address from the teach pendant under About; you can set the IP address under Settings > Network.
1. In the same Python REPL as before, run: `rtde_c = rtde_control.RTDEControlInterface("your.UR.ip.here")`.
   If it says "Please enable remote control on the robot!" this is good - it successfully talked to the robot!
   If it says "No such host" or "Connection timeout" or "Connection refused" or other such, this is bad. See the troubleshooting section.

### Using the library

Refer to the UR RTDE [Examples](https://sdurobotics.gitlab.io/ur_rtde/examples/examples.html) and [API Reference](https://sdurobotics.gitlab.io/ur_rtde/api/api.html) to find out how to use the library.

For instance, the [Record Data Example](https://sdurobotics.gitlab.io/ur_rtde/examples/examples.html#record-data-example) shows how to record the robot data to a CSV file.
To run it in Python, go back to Git Bash and navigate (`cd`) to `examples/py`, and then run `python record_data_example.py -ip <your.UR.ip.here>` (or do the equivalent in Visual Studio or Powershell).
While it runs, you probably want to do something like move the robot or apply force to it.
Press `[Ctrl-C]` to stop the recording, and then you can see your CSV data in `robot_data.csv`.

You can optionally specify an output filename with `-o`; otherwise, `robot_data.csv` will get overwritten every time you run the script. You can also optionally specify a sampling frequency with `-f`.
So, for example, to record two different trials, you might do `python record_data_example.py -ip <your.UR.ip.here> -o trial_ONE.csv -f 123.4` followed by `python record_data_example.py -ip <your.UR.ip.here> -o trial_TWO.csv -f 567.8`.

You can modify the example to fit your use case: For example, to narrow down the variables that get recorded, change `rtde_r.startFileRecording(args.output)` in the record data example to
`rtde_r.startFileRecording(args.output, ['actual_q', 'actual_TCP_pose', 'whatever_other_stuff'])`. Or you could change the default frequency, etc.

### Troubleshooting and random notes

- If you are getting a CMake error about `distutils`, you may need to be using **Python 3.11 or lower**; `distutils` is [removed from Python 3.12 onwards](https://docs.python.org/3.12/whatsnew/3.12.html#distutils).
  If you need multiple Python versions installed on your machine, which someday you will, look into [pyenv](https://github.com/pyenv/pyenv) (here's [pyenv-win](https://github.com/pyenv-win/pyenv-win))
  or [conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html).
- If you are having trouble building, and you are retrying the build after changing something,
  make sure to first **delete any `CMakeCache.txt` and `CMakeFiles`** that may be lying around - even in a parent directory to the one you are working in
  (e.g. in the project root if you are in `/Build`)...
- If you are seeing "No such host" or "Connection timeout" or "Connection refused" when trying to initialize an RTDEWhateverInterface,
  try (from Git Bash or Powershell) doing **`ping <UR.ip.address.here>`** and see if there is a response. If there isn't, double check that you are connected via Ethernet or on the same wifi subnet.
- If you are still seeing "Connection timeout" or "Connection refused" when trying to initialize an RTDEWhateverInterface, try going to Settings > Security > Services (on the UR teach pendant) and **ensuring
  that Dashboard Server and RTDE are enabled**; Dashboard Server (port 29999) is for the Control interface and RTDE (port 30004) is for the Receive and IO interfaces.
- If you successfully communicate with the robot for a while and then start seeing odd behavior, for example reading the same return values for position/force/etc where they should be different,
  try calling **`rtde_x.isConnected()`** (where `rtde_x` is whatever you named your interface - `rtde_c`, `rtde_r`, `banana`, etc)
  to make sure the connection was not lost, perhaps from unplugging Ethernet to use the wifi, etc. If you get False, call `rtde_x.reconnect()`.
- If you installed Visual Studio but still prefer the command-line, [this doc](https://learn.microsoft.com/en-us/visualstudio/msbuild/walkthrough-using-msbuild?view=vs-2022)
  has information on where to find the `msbuild` executable in your Visual Studio install.
  I found mine at `C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe`.
