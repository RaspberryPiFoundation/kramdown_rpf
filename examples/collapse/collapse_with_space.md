## Step 2 - Test the PIR motion sensor

We're going to write some code to print out `Motion detected!` when the PIR sensor detects movement.

1. Open IDLE, create a new file and save it as **parent-detector.py**

    --- collapse ---
    ---  
    title: Opening IDLE
    image: images/idle.png
    ---

    [[[idle-opening]]]

    --- /collapse ---

1. Blab la
    ```python
    from gpiozero import MotionSensor

    pir = MotionSensor(4)
    ```

2. Bla bla

    ```python
    while True:
        if pir.motion_detected:
    	    print("Motion detected!")
    ```