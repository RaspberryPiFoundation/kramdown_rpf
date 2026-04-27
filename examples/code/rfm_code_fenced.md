```python line_numbers=true line_numbers_start=3 line_highlights=3,5-6 filename=button_press.py
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
```
