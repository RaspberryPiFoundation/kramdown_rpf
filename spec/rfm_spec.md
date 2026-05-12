---
title: Raspberry Flavoured Markdown — Draft Spec
---

# Raspberry Flavoured Markdown Spec — Draft spec

:::warning[This is a draft specification. It is not finalised and is subject to change]
:::

This document is the formal specification for the modern Raspberry Pi Flavoured Markdown syntax
(GFM + custom alert syntax). It is used to test the TypeScript renderer (`rpf-markdown-core`).

Each **example** below shows the markdown input above the `·` separator and the expected HTML output
below it. These examples are the canonical test suite.

---

## How to read this spec

```text
markdown input
·
<p>expected HTML output</p>
```

The separator is a middle dot (`·`) on its own line. Test runners split on `\n·\n`.

---

## Codeblock

````example
```python filename="button_press.py" line_numbers="true" line_number_start="3" line_highlights="3,5-6"
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
```
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
````

---

## Collapsible

```example
> [!ACCORDION] Downloading and installing the Raspberry Pi software
>
> Content here comes from the ingredient.
·
<div class="c-project-panel c-project-panel--ingredient">
  <h3 class="c-project-panel__heading js-project-panel__toggle">
    Downloading and installing the Raspberry Pi software
  </h3>

  <div class="c-project-panel__content u-hidden">
    <p>Content here comes from the ingredient.</p>
  </div>
</div>
```

---

## Task

```example
> [!TASK]
>
> Complete this step.
·
<div class="c-project-task">
  <input class="c-project-task__checkbox" type="checkbox" aria-label="Mark this task as complete" />
  <div class="c-project-task__body">
    <p>Complete this step.</p>
  </div>
</div>
```

---

## Hint (single)

```example
> [!HINT]
>
> Try this approach.
·
<div class="c-project-panel c-project-panel--hints">
  <h3 class="c-project-panel__heading js-project-panel__toggle">
    I need a hint
  </h3>

  <div class="c-project-panel__content js-project-panel--initialise-swiper u-hidden">
    <div class="c-project-panel__swiper">
      <div class="c-project-panel__swiper-wrapper">
        <div class="c-project-panel__swiper-slide">
          <p>Try this approach.</p>
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

## Hints (grouped)

```example
> [!HINT]
>
> Hint 1

> [!HINT]
>
> Hint 2
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

## Challenge

```example
> [!CHALLENGE]
>
> ## Challenge: Improving your drum
>
> + Can you change the sound that the drum makes when it's clicked?
>
>   ![screenshot](images/band-drum-sound.png)
>
> You can copy your existing code by right-clicking on it and clicking 'duplicate'.
>
> ### Save your project
·
<h2 id="challenge-improving-your-drum">Challenge: Improving your drum</h2>

<ul>
  <li>
    <p>Can you change the sound that the drum makes when it&rsquo;s clicked?</p>
    <p><img src="images/band-drum-sound.png" alt="screenshot" /></p>
  </li>
</ul>

<p>You can copy your existing code by right-clicking on it and clicking &lsquo;duplicate&rsquo;.</p>

<h3 id="save-your-project">Save your project</h3>
```

---

## Save block

```example
> [!SAVE]
·
<div class="c-project-panel c-project-panel--save">
  <h3 class="c-project-panel__heading">
    Save your project
  </h3>
</div>
```

---

## No-print

```example
> [!NOPRINT]
>
> Interactive-only content.
·
<div class="u-no-print">
  <p>Interactive-only content.</p>
</div>
```

---

## Print-only

```example
> [!PRINTONLY]
>
> Worksheet-only content.
·
<div class="u-print-only">
  <p>Worksheet-only content.</p>
</div>
```

---

## Page break

```example
<br class="page-break" />
·
<br class="page-break">
```

---

## Nested blocks

```example
> [!TASK]
>
> > [!HINT]
> >
> > Hint 1
>
> > [!HINT]
> >
> > Hint 2
·
<div class="c-project-task">
  <input class="c-project-task__checkbox" type="checkbox" aria-label="Mark this task as complete" />
  <div class="c-project-task__body">
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
  </div>
</div>
```

---

## Info block

```example
> [!INFO]
>
> **Term** is explained here.
·
<div style="border-left: solid; border-width:10px; border-color: #0faeb0; background-color: aliceblue; padding: 10px;">
  <p>
    <strong>Term</strong> is explained here.
  </p>
</div>
```

---

## Tip block

```example
> [!TIP]
>
> When you type an opening bracket, the code editor will automatically add a closing bracket.
·
<div class="c-project-callout c-project-callout--tip">
  <h3 id="tip">Tip</h3>
  <p>When you type an opening bracket, the code editor will automatically add a closing bracket.</p>
</div>
```

---

## Debug block

```example
> [!DEBUG]
>
> If you get an error then check your code really carefully.
·
<div class="c-project-callout c-project-callout--debug">
  <h3 id="debugging">Debugging</h3>
  <p>If you get an error then check your code really carefully.</p>
</div>
```

---

## Image

```example
![Alt](images/example.gif)
·
<p><img src="images/example.gif" alt="Alt" /></p>
```

---

## Inline class

```example
The `Looks`{:class="block3looks"} category.
·
<p>The <code class="block3looks">Looks</code> category.</p>
```
