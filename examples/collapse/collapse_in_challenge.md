## Step 5 - Record video to a file

Seeing the intruder on the screen in a camera preview isn't much help to you with detecting intruders into your room. Instead, let's record a video of the intruder for you to  view later on when you get home.

1. Create a variable called `filename` inside your infinite loop to store the video file name

    ```python
    filename = "intruder.h264"
    ```

    In case you are wondering, `.h264` is the video format

1. Find the line of code where you begin the camera preview and replace it with a line of code to start recording a video

    ```python
    camera.start_recording(filename)
    ```

1. Find the line of code where you stop the camera preview and replace it with a line of code to stop recording.

--- hints ---

--- hint ---
Look at the line of code you used to start recording and see if you can work out the code to stop recording
--- /hint ---

--- hint ---
Here is the finished code
```python
while True:
    filename = "intruder.h264"
    pir.wait_for_motion()
    camera.start_recording(filename)
    pir.wait_for_no_motion()
	camera.stop_recording()
```
--- /hint ---

--- /hints ---

1. Save and run your program by pressing **F5**. Check that a file called `intruder.h264` appears in the same folder as your `parent-detector.py` file.

--- challenge ---
Every time a new intruder triggers the motion sensor the video will be overwritten. If you have lots of pesky parents or brothers and sisters intruding into your room, you want to keep videos of all of them. Can you write some code to automatically find out the current date and time and add it to the video filename so that each video we take will have a different filename?

--- collapse ---
---
title: Getting the date and time in Python
image: 
---

[[[generic-python-timestamps]]]

--- /collapse ---

--- /challenge ---