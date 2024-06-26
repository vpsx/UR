[Click here for the UR RTDE on Windows guide.](ur-rtde-on-windows.md)

# UR

Python on Linux:
```
pip install ur_rtde
```
Receive interface example:
```
import rtde_receive
rtde_r = rtde_receive.RTDEReceiveInterface("UR.ip.address.here")
actual_q = rtde_r.getActualQ()
```

### Links
- URsim docker image docs https://hub.docker.com/r/universalrobots/ursim_e-series
- ROS UR driver docs on setting up URsim https://docs.ros.org/en/ros2_packages/rolling/api/ur_robot_driver/installation/ursim_docker.html
- UR docs on client interfaces; port list at bottom https://www.universal-robots.com/articles/ur/interface-communication/overview-of-client-interfaces/
- ur_rtde library: Basic use examples https://sdurobotics.gitlab.io/ur_rtde/examples/examples.html#basic-use
- ur_rtde library: Record data example https://sdurobotics.gitlab.io/ur_rtde/examples/examples.html#record-data-example
- UR ROS2 Driver github https://github.com/UniversalRobots/Universal_Robots_ROS2_Driver
- UR ROS2 Driver docs on network setup (of actual non-simulated UR, and using Ethernet) https://docs.ros.org/en/ros2_packages/rolling/api/ur_robot_driver/installation/robot_setup.html#network-setup
- Universal Robots Github https://github.com/UniversalRobots
- About RTDE https://www.universal-robots.com/articles/ur/interface-communication/real-time-data-exchange-rtde-guide/ 

---
The mission is to get force data from a UR5e... _on a Windows machine_. So:

- UR "Developer Network" https://www.universal-robots.com/developer/
- Integrate Equipment > Advanced Communication https://www.universal-robots.com/developer/integrate-equipment/
- Client Libraries https://www.universal-robots.com/developer/insights/client-libraries-for-external-monitoring-and-control/
  - Universal Robots Client Library for C++ only works on Linux because it uses Linux socket communication.
  - Universal Robots ROS2 Driver is built on top of the Client Library, so that wouldn't work for Windows either.
  - If Python is OK, then RTDE Python Client Library would be the way to go: https://github.com/UniversalRobots/RTDE_Python_Client_Library
  - But as there seems to be a Matlab need, UR RTDE it is. Also UR RTDE explicitly supports Windows.
    - gitlab https://gitlab.com/sdurobotics/ur_rtde
    - docs https://sdurobotics.gitlab.io/ur_rtde/








