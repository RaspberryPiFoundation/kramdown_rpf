--- code ---
---
language: python
line_numbers: false
line_number_start: 3
---
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
--- /code ---
