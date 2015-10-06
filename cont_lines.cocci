// Peter Senna Tschudin <peter.senna@gmail.com>
// Identify continuation lines that can be fixed
// Licensed under GPLv2

@initialize:python@
@@
def printer(p1, p2, f):
    if p1[0].line < p2[0].line:
        fp = open(p1[0].file, 'r')
        lines = fp.readlines()
        fp.close()

        first_l = int(p1[0].line) - 1
        last_l = int(p2[0].line)

        l1_str = lines[first_l]
        l1_first_char = len(l1_str) - len(l1_str.lstrip())
	l1_tabs_cnt = l1_str[0:l1_first_char].count('\t')
	l1_whites_cnt = l1_str[0:l1_first_char].count(' ')

        for i in range(first_l + 1, last_l):
	    ln_str = lines[i]
            ln_first_char = len(ln_str) - len(ln_str.lstrip())
            ln_tabs_cnt = ln_str[0:ln_first_char].count('\t')
            ln_whites_cnt = ln_str[0:ln_first_char].count(' ')

            str_to_print = ""
            if ln_tabs_cnt != l1_tabs_cnt + 2:
                str_to_print = ":" + str(i + 1) + " " + f

            if ln_whites_cnt > 0:
                if str_to_print:
                    str_to_print += " ***"
                else:
                    str_to_print = ":" + str(i + 1) + " " + f + " ***"

            if str_to_print:
                print str_to_print


// Function call
@r1@
identifier f;
position p1, p2;
@@
f@p1(...)@p2

@script:python@
p1 << r1.p1;
p2 << r1.p2;
f << r1.f;
@@
printer(p1, p2, f)

// Function declaration
@r2@
identifier f;
position p1, p2;
@@
f@p1(...)@p2
{...}

@script:python@
p1 << r2.p1;
p2 << r2.p2;
f << r2.f;
@@
printer(p1, p2, f)

// Iterators
@r3@
iterator i;
position p1, p2;
@@
i@p1(...)@p2
{...}

@script:python@
p1 << r3.p1;
p2 << r3.p2;
i << r3.i;
@@
printer(p1, p2, i)

// Loops
@r4@
position p1, p2;
statement S;
@@
(
if@p1(...)@p2 S
|
for@p1(...;...;...)@p2 S
|
while@p1(...)@p2 S
)
@script:python@
p1 << r4.p1;
p2 << r4.p2;
@@
printer(p1, p2, "loop")
