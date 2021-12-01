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
