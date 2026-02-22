import re

with open('/home/steve/Documents/KLTN/bao-cao/KLTN-template.tex', 'r') as f:
    lines = f.readlines()

current_section = ""
fig_count = 0
for i, line in enumerate(lines):
    if line.startswith('\\chapter') or line.startswith('\\section') or line.startswith('\\subsection') or line.startswith('\\subsubsection'):
        current_section = line.strip()
    if '\\begin{figure}' in line:
        fig_count += 1
        label = ""
        path = ""
        for j in range(i, i+15):
            if '\\label' in lines[j]:
                label = lines[j].strip()
            if '\\includegraphics' in lines[j]:
                path = lines[j].strip().split(']{')[-1].split('}')[0]
                if 'width' not in lines[j]:
                    path = lines[j].strip().split('{')[-1].split('}')[0]
        print(f"Figure {fig_count} (line {i+1}): {path} -> {current_section}")
