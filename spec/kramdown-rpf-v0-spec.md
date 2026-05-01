---
title: Kramdown RPF v0 Spec
---

# Spec — kramdown-rpf version 0.12.0

This document is the formal specification for the custom block syntax used in Raspberry Pi Foundation
project content. It is parsed by `kramdown-rpf` (Ruby) and the TypeScript renderer.

Each **example** below shows the markdown input above the `·` separator and the expected HTML output
below it. These examples are the canonical test suite — the parsers in both renderers are expected to
produce output that matches exactly (modulo leading/trailing whitespace).

---

## How to read this spec

```text
This is the markdown input.
·
<p>This is the expected HTML output.</p>
```

The separator is a middle dot (`·`) on its own line. Test runners split on `\n·\n`.

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
  <h3 class="c-project-panel__heading js-project-panel__toggle">
    I need a hint
  </h3>

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

A `task` block renders as a checkable task item. Content inside is parsed as markdown.

```example
--- task ---

Complete this step.

--- /task ---
·
<div class="c-project-task">
  <input class="c-project-task__checkbox" type="checkbox" aria-label="Mark this task as complete" />
  <div class="c-project-task__body">
    <p>Complete this step.</p>

  </div>
</div>
```

A `task` block can contain code fences, hints, and collapse blocks.

````example
--- task ---

Add this code:

```python
print('hello')
```

--- /task ---
·
<div class="c-project-task">
  <input class="c-project-task__checkbox" type="checkbox" aria-label="Mark this task as complete" />
  <div class="c-project-task__body">
    <p>Add this code:</p>

<pre><code class="language-python">print('hello')
</code></pre>

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
print(&quot;Hello, World!&quot;)
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
print(&quot;Hello, World!&quot;)
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
print(&quot;Hello, World!&quot;)
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
print(&quot;Hello, World!&quot;)
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
    os.system(&quot;aplay {0}&quot;.format(parp))
    sleep(2)
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
  <h3 class="c-project-panel__heading js-project-panel__toggle">
    How to do something
  </h3>

  <div class="c-project-panel__content u-hidden">
    <p>Here is some useful information.</p>

  </div>
</div>
```

---

## Save

The `save` tag renders a "Save your project" panel. It takes no content.

```example
--- save ---
·
<div class="c-project-panel c-project-panel--save">
  <h3 class="c-project-panel__heading">
    Save your project
  </h3>
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
    <h3 class="c-project-quiz__heading">
      How are you feeling?
    </h3>

    <div class="c-project-quiz__content">
      <label class="c-project-quiz__label" for="choice-1">Good</label>
      <input class="c-project-quiz__input" name="quiz-choice" type="radio" id="choice-1" value="choice-1" />
      <label class="c-project-quiz__label" for="choice-2">Bad</label>
      <input class="c-project-quiz__input" name="quiz-choice" type="radio" id="choice-2" value="choice-2" />
      <label class="c-project-quiz__label" for="choice-3">Okay</label>
      <input class="c-project-quiz__input" name="quiz-choice" type="radio" id="choice-3" value="choice-3" />
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
<input type="radio" name="answer" value="1" id="choice-1" />
<label for="choice-1"><p>3</p></label>
</div>
<div class="knowledge-quiz-question__answer">
<input type="radio" name="answer" value="2" id="choice-2" checked/>
<label for="choice-2"><p>4</p></label>
</div>
<div class="knowledge-quiz-question__answer">
<input type="radio" name="answer" value="3" id="choice-3" />
<label for="choice-3"><p>5</p></label>
</div>
    </div>
  </fieldset>

  <input type="button" name="Submit" value="submit" />
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
<input type="radio" name="answer" value="1" id="choice-1" />
<label for="choice-1"><p>3</p></label>
</div>
<div class="knowledge-quiz-question__answer">
<input type="radio" name="answer" value="2" id="choice-2" checked/>
<label for="choice-2"><p>4</p></label>
</div>
<div class="knowledge-quiz-question__answer">
<input type="radio" name="answer" value="3" id="choice-3" />
<label for="choice-3"><p>5</p></label>
</div>
    </div>
  </fieldset>

  <input type="button" name="Submit" value="submit" />
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
<input type="radio" name="answer" value="1" id="choice-1" checked/>
<label for="choice-1"><p>Yes</p></label>
</div>
<div class="knowledge-quiz-question__answer">
<input type="radio" name="answer" value="2" id="choice-2" />
<label for="choice-2"><p>No</p></label>
</div>
    </div>
  </fieldset>
  <ul class="knowledge-quiz-question__feedback">
  <li class="knowledge-quiz-question__feedback-item" id="feedback-for-choice-2">
<p>Look outside on a clear day.</p>
</li>
</ul>
  <input type="button" name="Submit" value="submit" />
</form>
```

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
