---
title: Kramdown RPF -- Legacy spec
---

# Spec — kramdown-rpf version 0.12.0

:::info
This spec was built from the example files in the `kramdown-rpf` repository. It
is intended to be a single source of truth for the expected behaviour of the
custom block syntax, and to be used as the basis for test suites in both the
Ruby and TypeScript renderers. Any changes to the syntax or expected output
should be made here first, and then the tests in both repositories should be
updated to match.
:::

This document is the formal specification for the **legacy** custom block syntax used in
Raspberry Pi Foundation project content. It is parsed by `kramdown-rpf` (Ruby)
and the `rpf-markdown-core` (TypeScript) renderers.

Each **example** below shows the markdown input above the `·` separator and the
expected HTML output below it. These examples are the canonical test suite —
the parsers in both renderers are expected to produce output that matches
exactly (modulo leading/trailing whitespace).

This spec replaces the original `example/` directory in the `kramdown-rpf`
repository. It is intended to be a single source of truth for the expected
behaviour of the custom block syntax, and to be used as the basis for test
suites in both the Ruby and TypeScript renderers. Any changes to the syntax or
expected output should be made here first, and then the tests in both
repositories should be updated to match.

---

## How to read this spec

```text
This is the markdown input.
·
<p>This is the expected HTML output.</p>
```

The separator is a middle dot (`·`) on its own line. Test runners split on
`\n·\n`.

---

## Hint

A single `hint` block renders as a swiper slide. It is always used inside a `hints` block in
practice but can be used standalone.

```example
--- hint ---

Some hint content

--- /hint ---
·
<div class="c-project-panel__swiper-slide">
  <p>Some hint content</p>
</div>
```

---

## Hints

A `hints` block wraps one or more `hint` blocks in a swiper panel with pagination controls.

```example
--- hints ---
--- hint ---

Hint 1

--- /hint ---
--- hint ---

Hint 2

--- /hint ---

--- /hints ---
·
<div class="c-project-panel c-project-panel--hints">
  <h3 class="c-project-panel__heading js-project-panel__toggle">I need a hint</h3>
  <div class="c-project-panel__content js-project-panel--initialise-swiper u-hidden">
    <div class="c-project-panel__swiper">
      <div class="c-project-panel__swiper-wrapper">
        <div class="c-project-panel__swiper-slide">
          <p>Hint 1</p>
        </div>
        <div class="c-project-panel__swiper-slide">
          <p>Hint 2</p>
        </div>
      </div>
      <div class="c-project-panel__swiper-pagination">
        <span class="c-project-panel__swiper-bullet"></span>
        <span class="c-project-panel__swiper-bullet"></span>
        <span class="c-project-panel__swiper-bullet"></span>
      </div>
      <div class="c-project-panel__swiper-button c-project-panel__swiper-button--next"></div>
      <div class="c-project-panel__swiper-button c-project-panel__swiper-button--prev"></div>
    </div>
  </div>
</div>
```

---

## Task

A `task` block renders as a checkable task item. Content inside is parsed as markdown. It can contain code fences, hints, and collapse blocks.

````example
--- task ---

Add global direction to your function:

```
def joystick_moved(event):
  global direction
```

You can access the direction the joystick was moved in with the help of the event parameter: use the command `event.direction`.
--- /task ---
·
<div class="c-project-task">
  <input class="c-project-task__checkbox" type="checkbox" aria-label="Mark this task as complete" />
  <div class="c-project-task__body">
    <p>Add global direction to your function:</p>

<pre><code>def joystick_moved(event):
  global direction
</code></pre>

    <p>You can access the direction the joystick was moved in with the help of the event parameter: use the command <code>event.direction</code>.</p>
  </div>
</div>
````

### With hints

````example
--- task ---

Add global direction to your function:

```
def joystick_moved(event):
  global direction
```

You can access the direction the joystick was moved in with the help of the event parameter: use the command `event.direction`.

--- hints ---
--- hint ---

Hint 1

--- /hint ---
--- hint ---
Hint 2

--- /hint ---
--- hint ---

Hint 3
--- /hint ---
--- hint ---
Hint 4
--- /hint ---

--- /hints ---

--- /task ---
·
<div class="c-project-task">
  <input class="c-project-task__checkbox" type="checkbox" aria-label="Mark this task as complete">
  <div class="c-project-task__body">
    <p>Add global direction to your function:</p>
    <pre><code>def joystick_moved(event):
  global direction
</code></pre>
    <p>You can access the direction the joystick was moved in with the help of the event parameter: use the command <code>event.direction</code>.</p>
    <div class="c-project-panel c-project-panel--hints">
      <h3 class="c-project-panel__heading js-project-panel__toggle">I need a hint</h3>
      <div class="c-project-panel__content js-project-panel--initialise-swiper u-hidden">
        <div class="c-project-panel__swiper">
          <div class="c-project-panel__swiper-wrapper">
            <div class="c-project-panel__swiper-slide">
              <p>Hint 1</p>
            </div>
            <div class="c-project-panel__swiper-slide">
              <p>Hint 2</p>
            </div>
            <div class="c-project-panel__swiper-slide">
              <p>Hint 3</p>
            </div>
            <div class="c-project-panel__swiper-slide">
              <p>Hint 4</p>
            </div>
          </div>
          <div class="c-project-panel__swiper-pagination">
            <span class="c-project-panel__swiper-bullet"></span>
            <span class="c-project-panel__swiper-bullet"></span>
            <span class="c-project-panel__swiper-bullet"></span>
          </div>
          <div class="c-project-panel__swiper-button c-project-panel__swiper-button--next"></div>
          <div class="c-project-panel__swiper-button c-project-panel__swiper-button--prev"></div>
        </div>
      </div>
    </div>
  </div>
</div>
````

### With ingredient

````example
--- task ---

Add global direction to your function:

```
def joystick_moved(event):
  global direction
```

You can access the direction the joystick was moved in with the help of the event parameter: use the command `event.direction`.

--- collapse ---
---
title: Downloading and installing the Raspberry Pi software
---

Content here comes from the ingredient.

--- /collapse ---

--- /task ---
·
<div class="c-project-task">
  <input class="c-project-task__checkbox" type="checkbox" aria-label="Mark this task as complete">
  <div class="c-project-task__body">
    <p>Add global direction to your function:</p>
    <pre><code>def joystick_moved(event):
  global direction
</code></pre>
    <p>You can access the direction the joystick was moved in with the help of the event parameter: use the command <code>event.direction</code>.</p>
    <div class="c-project-panel c-project-panel--ingredient">
      <h3 class="c-project-panel__heading js-project-panel__toggle">Downloading and installing the Raspberry Pi software</h3>
      <div class="c-project-panel__content u-hidden">
        <p>Content here comes from the ingredient.</p>
      </div>
    </div>
  </div>
</div>
````

---

## Challenge

A `challenge` block contains optional markdown content. It has no wrapping element — its content is
rendered directly into the document flow.

```example
--- challenge ---

## Challenge: Try something new

Can you improve your project?

--- /challenge ---
·
<h2 id="challenge-try-something-new">Challenge: Try something new</h2>
<p>Can you improve your project?</p>
```

---

## Code block

The `code` block provides a styled code display with optional filename, line numbers, and line
highlights. It uses a YAML front matter section to configure the display.

### Language only

```example
--- code ---
---
language: python
---
print("Hello, World!")
--- /code ---
·
<pre dir="ltr"><code class="language-python" dir="ltr">
print("Hello, World!")
</code></pre>
```

### With filename

```example
--- code ---
---
language: python
filename: hello.py
---
print("Hello, World!")
--- /code ---
·
<div class="c-code-filename">
  hello.py
</div>
<pre dir="ltr"><code class="language-python" dir="ltr">
print("Hello, World!")
</code></pre>
```

### With line numbers

```example
--- code ---
---
language: python
line_numbers: true
---
print("Hello, World!")
--- /code ---
·
<pre dir="ltr" class="line-numbers"><code class="language-python" dir="ltr">
print("Hello, World!")
</code></pre>
```

### With line highlights

```example
--- code ---
---
language: python
line_highlights: 1
---
print("Hello, World!")
--- /code ---
·
<pre dir="ltr" data-line="1"><code class="language-python" dir="ltr">
print("Hello, World!")
</code></pre>
```

### With all features

```example
--- code ---
---
filename: button_press.py
language: python
line_numbers: true
line_number_start: 3
line_highlights: 3, 5-6
---
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
--- /code ---
·
<div class="c-code-filename">
  button_press.py
</div>
<pre dir="ltr" class="line-numbers" data-start="3" data-line-offset="3" data-line="3, 5-6"><code class="language-python" dir="ltr">
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
</code></pre>
```

### Fenced

A plain fenced code block.

````example
```python
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
```
·
<pre><code class="language-python">while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
</code></pre>
````

### With multi-line content

```example
--- code ---
---
language: python
---
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
--- /code ---
·
<pre dir="ltr"><code class="language-python" dir="ltr">
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
</code></pre>
```

### With line numbers disabled

```example
--- code ---
---
language: python
line_numbers: false
---
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
--- /code ---
·
<pre dir="ltr" class="no-line-numbers"><code class="language-python" dir="ltr">
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
</code></pre>
```

### With angle brackets in content

```example
--- code ---
---
language: cs
filename: StarController.cs - OnTriggerEnter(Collider other)
line_numbers: true
line_number_start: 21
line_highlights: 26, 27
---
    void OnTriggerEnter(Collider other)
    {
        // Check the tag of the colliding object
        if (other.CompareTag("Player"))
        {
            StarPlayer player = other.gameObject.GetComponent<StarPlayer>();
            player.stars += 1; // Increase by 1
            AudioSource.PlayClipAtPoint(collectSound, transform.position);
            gameObject.SetActive(false);
        }
    }
--- /code ---
·
<div class="c-code-filename">
  StarController.cs - OnTriggerEnter(Collider other)
</div>
<pre dir="ltr" class="line-numbers" data-start="21" data-line-offset="21" data-line="26, 27"><code class="language-cs" dir="ltr">
    void OnTriggerEnter(Collider other)
    {
        // Check the tag of the colliding object
        if (other.CompareTag("Player"))
        {
            StarPlayer player = other.gameObject.GetComponent&lt;StarPlayer&gt;();
            player.stars += 1; // Increase by 1
            AudioSource.PlayClipAtPoint(collectSound, transform.position);
            gameObject.SetActive(false);
        }
    }
</code></pre>
```

---

## Collapse

A `collapse` block renders as a collapsible ingredient panel. It requires a YAML front matter section
with a `title` field. The body is parsed as markdown.

```example
--- collapse ---
---
title: How to do something
---

Here is some useful information.

--- /collapse ---
·
<div class="c-project-panel c-project-panel--ingredient">
  <h3 class="c-project-panel__heading js-project-panel__toggle">How to do something</h3>
  <div class="c-project-panel__content u-hidden">
    <p>Here is some useful information.</p>
  </div>
</div>
```

### With code block in body

```example
--- collapse ---
---
title: Child project
---
<div class="c-code-filename">
  main.py
</div>
<pre dir="ltr" class="line-numbers" data-start="1" data-line="2"><code class="language-python" dir="ltr">
vowels = 'AEIOU' # The variable holds a string of vowels
vowel_list = list(vowels) # Create a list that holds each vowel as a separate item
print(vowel_list) # Display the list of vowels
</code></pre>

<p>The output of this code would be:</p>

<pre><code>['A', 'E', 'I', 'O', 'U']
</code></pre>


--- /collapse ---

1.  Now that you know how to get Steve's position, you can begin your program by storing his poition as three variables. You can use `px`, `py`, and `pz`

~~~ python
px, py, pz = mc.player.getPos()
~~~
·
<div class="c-project-panel c-project-panel--ingredient">
  <h3 class="c-project-panel__heading js-project-panel__toggle">Child project</h3>
  <div class="c-project-panel__content u-hidden">
    <div class="c-code-filename">
      <p>main.py</p>
    </div>
    <pre dir="ltr" class="line-numbers" data-start="1" data-line="2"><code class="language-python" dir="ltr">
vowels = 'AEIOU' # The variable holds a string of vowels
vowel_list = list(vowels) # Create a list that holds each vowel as a separate item
print(vowel_list) # Display the list of vowels
</code></pre>
    <p>The output of this code would be:</p>
    <pre><code>['A', 'E', 'I', 'O', 'U']
</code></pre>
  </div>
</div>
<ol>
  <li>Now that you know how to get Steve’s position, you can begin your program by storing his poition as three variables. You can use <code>px</code>, <code>py</code>, and <code>pz</code></li>
</ol>
<pre><code class="language-python">px, py, pz = mc.player.getPos()
</code></pre>
```

### Inside a list item

````example
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
·
<h2 id="step-2---test-the-pir-motion-sensor">Step 2 - Test the PIR motion sensor</h2>
<p>We’re going to write some code to print out <code>Motion detected!</code> when the PIR sensor detects movement.</p>
<ol>
  <li>
    <p>Open IDLE, create a new file and save it as <strong>parent-detector.py</strong></p>
    <div class="c-project-panel c-project-panel--ingredient">
      <h3 class="c-project-panel__heading js-project-panel__toggle">Opening IDLE</h3>
      <div class="c-project-panel__content u-hidden">
        <p>[[[idle-opening]]]</p>
      </div>
    </div>
  </li>
  <li>Blab la
    <pre><code class="language-python"> from gpiozero import MotionSensor

 pir = MotionSensor(4)
</code></pre>
  </li>
  <li>
    <p>Bla bla</p>
    <pre><code class="language-python"> while True:
     if pir.motion_detected:
            print("Motion detected!")
</code></pre>
  </li>
</ol>
````

### With HTML body

```example
--- collapse ---
---
title: Creating Directories on a Raspberry Pi
---
<h2 id="creating-directories-on-a-raspberry-pi">Creating Directories on a Raspberry Pi</h2>

<p>There are two ways to create directories on the Raspberry Pi. The first uses the GUI, and the second uses the Terminal.</p>

<h3 id="method-1---using-the-gui">Method 1 - Using the GUI</h3>

<p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/GUI-make-directory.gif" alt="GUI-make-directory" /></p>

<ol>
  <li>
    <p>Open a File Manager window by clicking on the icon in the top left corner of the screen</p>

    <p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/file-manager.png" alt="file-manager" /></p>
  </li>
  <li>In the window, right-click and select <em>Create New…</em> and then <em>Folder</em> from the context menu</li>
  <li>In the dialogue box, type the name of your new directory and then click <em>OK</em></li>
</ol>

<h3 id="method-2---using-the-terminal">Method 2 - Using the Terminal</h3>

<p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/Terminal-make-directory.gif" alt="Terminal-make-directory" /></p>

<ol>
  <li>
    <p>Open a new Terminal window by clicking on the icon in the top left corner of the screen.</p>

    <p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/terminal.png" alt="terminal" /></p>
  </li>
  <li>
    <p>You can create a new directory using the <code>mkdir</code> command</p>

    <div class="language-bash highlighter-coderay"><div class="CodeRay">
  <div class="code"><pre> mkdir my-new-directory
</pre></div>
</div>
    </div>
  </li>
  <li>You can list the contents of the current directory using <code>ls</code></li>
  <li>
    <p>To enter your new directory use the <code>cd</code> command</p>

    <div class="language-bash highlighter-coderay"><div class="CodeRay">
  <div class="code"><pre> cd my-new-directory
</pre></div>
</div>
    </div>
  </li>
</ol>


--- /collapse ---
·
<div class="c-project-panel c-project-panel--ingredient">
  <h3 class="c-project-panel__heading js-project-panel__toggle">Creating Directories on a Raspberry Pi</h3>
  <div class="c-project-panel__content u-hidden">
    <h2 id="creating-directories-on-a-raspberry-pi">Creating Directories on a Raspberry Pi</h2>
    <p>There are two ways to create directories on the Raspberry Pi. The first uses the GUI, and the second uses the Terminal.</p>
    <h3 id="method-1---using-the-gui">Method 1 - Using the GUI</h3>
    <p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/GUI-make-directory.gif" alt="GUI-make-directory"></p>
    <ol>
      <li>
        <p>Open a File Manager window by clicking on the icon in the top left corner of the screen</p>
        <p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/file-manager.png" alt="file-manager"></p>
      </li>
      <li>In the window, right-click and select <em>Create New…</em> and then <em>Folder</em> from the context menu</li>
      <li>In the dialogue box, type the name of your new directory and then click <em>OK</em></li>
    </ol>
    <h3 id="method-2---using-the-terminal">Method 2 - Using the Terminal</h3>
    <p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/Terminal-make-directory.gif" alt="Terminal-make-directory"></p>
    <ol>
      <li>
        <p>Open a new Terminal window by clicking on the icon in the top left corner of the screen.</p>
        <p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/terminal.png" alt="terminal"></p>
      </li>
      <li>
        <p>You can create a new directory using the <code>mkdir</code> command</p>
        <div class="language-bash highlighter-coderay">
          <div class="CodeRay">
            <div class="code">
              <pre> mkdir my-new-directory
</pre>
            </div>
          </div>
        </div>
      </li>
      <li>You can list the contents of the current directory using <code>ls</code></li>
      <li>
        <p>To enter your new directory use the <code>cd</code> command</p>
        <div class="language-bash highlighter-coderay">
          <div class="CodeRay">
            <div class="code">
              <pre> cd my-new-directory
</pre>
            </div>
          </div>
        </div>
      </li>
    </ol>
  </div>
</div>
```

### Inside a challenge

````example
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
·
<h2 id="step-5---record-video-to-a-file">Step 5 - Record video to a file</h2>
<p>Seeing the intruder on the screen in a camera preview isn’t much help to you with detecting intruders into your room. Instead, let’s record a video of the intruder for you to view later on when you get home.</p>
<ol>
  <li>
    <p>Create a variable called <code>filename</code> inside your infinite loop to store the video file name</p>
    <pre><code class="language-python"> filename = "intruder.h264"
</code></pre>
    <p>In case you are wondering, <code>.h264</code> is the video format</p>
  </li>
  <li>
    <p>Find the line of code where you begin the camera preview and replace it with a line of code to start recording a video</p>
    <pre><code class="language-python"> camera.start_recording(filename)
</code></pre>
  </li>
  <li>
    <p>Find the line of code where you stop the camera preview and replace it with a line of code to stop recording.</p>
  </li>
</ol>
<div class="c-project-panel c-project-panel--hints">
  <h3 class="c-project-panel__heading js-project-panel__toggle">I need a hint</h3>
  <div class="c-project-panel__content js-project-panel--initialise-swiper u-hidden">
    <div class="c-project-panel__swiper">
      <div class="c-project-panel__swiper-wrapper">
        <div class="c-project-panel__swiper-slide">
          <p>Look at the line of code you used to start recording and see if you can work out the code to stop recording</p>
        </div>
        <div class="c-project-panel__swiper-slide">
          <p>Here is the finished code</p>
          <pre><code class="language-python">while True:
    filename = "intruder.h264"
    pir.wait_for_motion()
    camera.start_recording(filename)
    pir.wait_for_no_motion()
        camera.stop_recording()
</code></pre>
        </div>
      </div>
      <div class="c-project-panel__swiper-pagination">
        <span class="c-project-panel__swiper-bullet"></span>
        <span class="c-project-panel__swiper-bullet"></span>
        <span class="c-project-panel__swiper-bullet"></span>
      </div>
      <div class="c-project-panel__swiper-button c-project-panel__swiper-button--next"></div>
      <div class="c-project-panel__swiper-button c-project-panel__swiper-button--prev"></div>
    </div>
  </div>
</div>
<ol>
  <li>Save and run your program by pressing <strong>F5</strong>. Check that a file called <code>intruder.h264</code> appears in the same folder as your <code>parent-detector.py</code> file.</li>
</ol>
<p>Every time a new intruder triggers the motion sensor the video will be overwritten. If you have lots of pesky parents or brothers and sisters intruding into your room, you want to keep videos of all of them. Can you write some code to automatically find out the current date and time and add it to the video filename so that each video we take will have a different filename?</p>
<div class="c-project-panel c-project-panel--ingredient">
  <h3 class="c-project-panel__heading js-project-panel__toggle">Getting the date and time in Python</h3>
  <div class="c-project-panel__content u-hidden">
    <p>[[[generic-python-timestamps]]]</p>
  </div>
</div>
````

---

## Save

The `save` tag renders a "Save your project" panel. It takes no content.

```example
--- save ---
·
<div class="c-project-panel c-project-panel--save">
  <h3 class="c-project-panel__heading">Save your project</h3>
</div>
```

---

## New page

The `new-page` tag inserts a print page break.

```example
First Page

--- new-page ---

Second Page
·
<p>First Page</p>
<div class="c-print-page-break"></div>
<p>Second Page</p>
```

---

## No print

Content inside a `no-print` block is hidden when printing.

```example
--- no-print ---
This won't print.
--- /no-print ---
·
<div class="u-no-print">
  <p>This won’t print.</p>
</div>
```

---

## Print only

Content inside a `print-only` block is only visible when printing.

```example
--- print-only ---
This only appears in print.
--- /print-only ---
·
<div class="u-print-only">
  <p>This only appears in print.</p>
</div>
```

---

## Quiz

A `quiz` block renders a simple radio button poll. The question is defined in YAML front matter and
the choices are a markdown list of radio items using `( )` notation.

```example
--- quiz ---
---
question: How are you feeling?
---

- ( ) Good
- ( ) Bad
- ( ) Okay

--- /quiz ---
·
<div class="c-project-quiz">
  <form class="c-project-quiz__form" action="#">
    <h3 class="c-project-quiz__heading">How are you feeling?</h3>
    <div class="c-project-quiz__content">
      <label class="c-project-quiz__label" for="choice-1">Good</label>
      <input class="c-project-quiz__input" name="quiz-choice" type="radio" id="choice-1" value="choice-1">
      <label class="c-project-quiz__label" for="choice-2">Bad</label>
      <input class="c-project-quiz__input" name="quiz-choice" type="radio" id="choice-2" value="choice-2">
      <label class="c-project-quiz__label" for="choice-3">Okay</label>
      <input class="c-project-quiz__input" name="quiz-choice" type="radio" id="choice-3" value="choice-3">
    </div>
    <div class="c-project-quiz__button-bar"></div>
  </form>
</div>
```

---

## Knowledge quiz question

A `question` block renders a self-marking quiz question. It contains a `choices` block with radio
items using `( )` for incorrect and `(x)` for the correct answer. Optional `feedback` blocks provide
per-choice feedback.

### Simple question

```example
--- question ---

What is 2 + 2?

--- choices ---

- ( ) 3
- (x) 4
- ( ) 5

--- /choices ---

--- /question ---
·
<form class="knowledge-quiz-question">
  <fieldset>
    <legend>Question</legend>
    <div class="knowledge-quiz-question__blurb">
      <p>What is 2 + 2?</p>
    </div>
    <div class="knowledge-quiz-question__answers">
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="1" id="choice-1">
        <label for="choice-1"><p>3</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="2" id="choice-2" checked>
        <label for="choice-2"><p>4</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="3" id="choice-3">
        <label for="choice-3"><p>5</p></label>
      </div>
    </div>
  </fieldset><input type="button" name="Submit" value="submit">
</form>
```

### With legend front matter

The legend can be overridden via a YAML front matter section inside the `question` block.

```example
--- question ---

---
legend: Question 1 of 3
---

What is 2 + 2?

--- choices ---

- ( ) 3
- (x) 4
- ( ) 5

--- /choices ---

--- /question ---
·
<form class="knowledge-quiz-question">
  <fieldset>
    <legend>Question 1 of 3</legend>
    <div class="knowledge-quiz-question__blurb">
      <p>What is 2 + 2?</p>
    </div>
    <div class="knowledge-quiz-question__answers">
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="1" id="choice-1">
        <label for="choice-1"><p>3</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="2" id="choice-2" checked>
        <label for="choice-2"><p>4</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="3" id="choice-3">
        <label for="choice-3"><p>5</p></label>
      </div>
    </div>
  </fieldset><input type="button" name="Submit" value="submit">
</form>
```

### With per-choice feedback

```example
--- question ---

Is the sky blue?

--- choices ---

- (x) Yes

- ( ) No

  --- feedback ---
  Look outside on a clear day.
  --- /feedback ---

--- /choices ---

--- /question ---
·
<form class="knowledge-quiz-question">
  <fieldset>
    <legend>Question</legend>
    <div class="knowledge-quiz-question__blurb">
      <p>Is the sky blue?</p>
    </div>
    <div class="knowledge-quiz-question__answers">
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="1" id="choice-1" checked>
        <label for="choice-1"><p>Yes</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="2" id="choice-2">
        <label for="choice-2"><p>No</p></label>
      </div>
    </div>
  </fieldset>
  <ul class="knowledge-quiz-question__feedback">
    <li class="knowledge-quiz-question__feedback-item" id="feedback-for-choice-2">
      <p>Look outside on a clear day.</p>
    </li>
  </ul><input type="button" name="Submit" value="submit">
</form>
```

### With single feedback

```example
--- question ---

What food will the bug reach when these instructions are followed?

![A bug in a crossword-like maze with various bits of food scattered around](./img/q2.svg)

1. Forward
2. Forward
3. Forward
4. Turn left
5. Forward
6. Forward
7. Turn right
8. Forward
9. Forward
10. Turn right
11. Forward
12. Forward

--- choices ---

--- feedback ---
Follow the instructions one at a time.  Which food item does the bug reach?
--- /feedback ---

- (x) Apple
- ( ) Banana
- ( ) Orange
- ( ) Doughnut

--- /choices ---

--- /question ---
·
<form class="knowledge-quiz-question">
  <fieldset>
    <legend>Question</legend>
    <div class="knowledge-quiz-question__blurb">
      <p>What food will the bug reach when these instructions are followed?</p>
      <p><img src="./img/q2.svg" alt="A bug in a crossword-like maze with various bits of food scattered around"></p>
      <ol>
        <li>Forward</li>
        <li>Forward</li>
        <li>Forward</li>
        <li>Turn left</li>
        <li>Forward</li>
        <li>Forward</li>
        <li>Turn right</li>
        <li>Forward</li>
        <li>Forward</li>
        <li>Turn right</li>
        <li>Forward</li>
        <li>Forward</li>
      </ol>
    </div>
    <div class="knowledge-quiz-question__answers">
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="1" id="choice-1" checked>
        <label for="choice-1"><p>Apple</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="2" id="choice-2">
        <label for="choice-2"><p>Banana</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="3" id="choice-3">
        <label for="choice-3"><p>Orange</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="4" id="choice-4">
        <label for="choice-4"><p>Doughnut</p></label>
      </div>
    </div>
  </fieldset>
  <ul class="knowledge-quiz-question__feedback">
    <li class="knowledge-quiz-question__feedback-item" id="feedback">
      <p>Follow the instructions one at a time. Which food item does the bug reach?</p>
    </li>
  </ul><input type="button" name="Submit" value="submit">
</form>
```

### With blocks in feedback

````example
--- question ---

A dog sprite in Scratch has the following code:

![A dog with three scratch blocks](./images/q1.svg)

How would you get the dog sprite to change size?

--- choices ---

- ( ) Press the 'space' key

  --- feedback ---
  What code is attached to the
  ```blocks3
  when [space v] key pressed
  ```
  event block?
  --- /feedback ---

- ( ) Make a loud noise

  --- feedback ---
  What code is attached to the
  ```blocks3
  when [loudness v] > 10 :: events hat
  ```
  event block?
  --- /feedback ---

- ( ) Click the green flag

  --- feedback ---
  What code is attached to the
  ```blocks3
  when flag clicked
  ```
  event block?
  --- /feedback ---

- (x) Click on the dog sprite

--- /choices ---

--- /question ---
·
<form class="knowledge-quiz-question">
  <fieldset>
    <legend>Question</legend>
    <div class="knowledge-quiz-question__blurb">
      <p>A dog sprite in Scratch has the following code:</p>
      <p><img src="./images/q1.svg" alt="A dog with three scratch blocks"></p>
      <p>How would you get the dog sprite to change size?</p>
    </div>
    <div class="knowledge-quiz-question__answers">
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="1" id="choice-1">
        <label for="choice-1"><p>Press the ‘space’ key</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="2" id="choice-2">
        <label for="choice-2"><p>Make a loud noise</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="3" id="choice-3">
        <label for="choice-3"><p>Click the green flag</p></label>
      </div>
      <div class="knowledge-quiz-question__answer">
        <input type="radio" name="answer" value="4" id="choice-4" checked>
        <label for="choice-4"><p>Click on the dog sprite</p></label>
      </div>
    </div>
  </fieldset>
  <ul class="knowledge-quiz-question__feedback">
    <li class="knowledge-quiz-question__feedback-item" id="feedback-for-choice-1">
      <p>What code is attached to the</p>
      <pre><code class="language-blocks3">  when [space v] key pressed
</code></pre>
      <p>event block?</p>
    </li>
    <li class="knowledge-quiz-question__feedback-item" id="feedback-for-choice-2">
      <p>What code is attached to the</p>
      <pre><code class="language-blocks3">  when [loudness v] &gt; 10 :: events hat
</code></pre>
      <p>event block?</p>
    </li>
    <li class="knowledge-quiz-question__feedback-item" id="feedback-for-choice-3">
      <p>What code is attached to the</p>
      <pre><code class="language-blocks3">  when flag clicked
</code></pre>
      <p>event block?</p>
    </li>
  </ul><input type="button" name="Submit" value="submit">
</form>
````

---

## Microbit code block

A fenced code block with language `microbit` renders with the `language-microbit` class for the
Microbit simulator widget.

````example
```microbit
let x = 5
```
·
<pre><code class="language-microbit">let x = 5
</code></pre>
````

---

## Scratch code blocks

Fenced code blocks with language `blocks3` (Scratch 3) or `blocks` (Scratch 2) render with the
corresponding class for the scratchblocks rendering library.

````example
```blocks3
when flag clicked
```
·
<pre><code class="language-blocks3">when flag clicked
</code></pre>
````

````example
```blocks
when flag clicked
```
·
<pre><code class="language-blocks">when flag clicked
</code></pre>
````