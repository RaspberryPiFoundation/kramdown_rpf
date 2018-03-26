--- code ---
---
language: python
line_numbers: true
---
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
--- /code ---
