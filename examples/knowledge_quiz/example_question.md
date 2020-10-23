# Quiz introduction

The quiz can have normal HTML before it, which will just be treated like normal markdown.

Anything inside a `---question---` block will be parsed into a `<form>` representing the quiz question

A question may optionally have a 'frontmatter' section with the `legend` parameter to override the default 'Question' string used in the form's legend tag.

--- question ---

---
legend: Question 1 of 3
---

The bug sprite starts facing upwards.

![Bug facing upwards](./img/q3-1.png)

What code would you add to the bug sprite to draw this shape.

![Path drawn by the bug, with the bug at the end](./img/q3-2.png)

--- choices ---

- ( )
  ```blocks3
  when flag clicked
  pen down
  turn ccw (90) degrees
  move (100) steps
  turn cw (90) degrees
  move (100) steps
  ```

  --- feedback ---
  The number of ‘move’ blocks in the code should match the number of sides the shape has.
  --- /feedback ---

- ( )
  ```blocks3
  when flag clicked
  pen down
  turn cw (90) degrees
  move (100) steps
  turn ccw (90) degrees
  move (100) steps
  turn ccw (180) degrees
  move (100) steps
  ```

  --- feedback ---
  To draw this shape, the direction of the ‘turn’ blocks should all be the same.
  --- /feedback ---

- (x)
  ```blocks3
  when flag clicked
  pen down
  turn ccw (90) degrees
  move (100) steps
  turn ccw (90) degrees
  move (100) steps
  turn ccw (90) degrees
  move (100) steps
  ```

- ( )
  ```blocks3
  when flag clicked
  pen down
  turn ccw (90) degrees
  turn ccw (90) degrees
  turn ccw (90) degrees
  ```

  --- feedback ---
  The sprite will need to move in order to draw a shape.
  --- /feedback ---

--- /choices ---

--- /question ---
