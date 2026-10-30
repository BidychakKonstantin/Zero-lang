#!/bin/sh
B=build
fail=0
for f in tests/*.zr; do
  n=${f%.zr}
  if ! ./$B/zero "$f" > $B/a.asm; then echo "FAIL zero: $f"; fail=1; continue; fi
  if ! ./$B/gen3 "$f" > $B/b.asm; then echo "FAIL gen3: $f"; fail=1; continue; fi
  if ! cmp -s $B/a.asm $B/b.asm; then echo "DIFF asm: $f"; fail=1; continue; fi
  if ! nasm -f elf64 $B/b.asm -o $B/t.o || ! ld $B/t.o $B/runtime.o -o $B/tbin; then
    echo "FAIL build: $f"; fail=1; continue
  fi
  ./$B/tbin > $B/actual.txt
  if cmp -s $B/actual.txt $n.out; then
    echo "ok   $f"
  else
    echo "BAD  $f"; diff $B/actual.txt $n.out | head; fail=1
  fi
done
[ $fail = 0 ] && echo "ALL OK"
exit $fail