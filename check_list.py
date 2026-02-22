import re

with open('/home/steve/Documents/KLTN/bao-cao/KLTN-template.tex', 'r') as f:
    lines = f.readlines()

list_depth = 0
for i, line in enumerate(lines):
    if '\\begin{itemize}' in line or '\\begin{enumerate}' in line:
        list_depth += 1
    elif '\\end{itemize}' in line or '\\end{enumerate}' in line:
        list_depth -= 1
    if '\\begin{figure}' in line and list_depth > 0:
        print(f"Line {i+1}: figure inside list (depth {list_depth})")
