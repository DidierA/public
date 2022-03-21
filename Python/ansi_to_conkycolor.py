#!/usr/bin/python3
"""ANSI Codes to conky ${color} converter

This script copies input to output, converting ANSI color  codes to conky's ${colorX}
Extended color codes are converted to #RRGGBB.

Usage: ansi_to_conkycolor.py [filename] [filename ...]
    if no argument is given, or '-' as filename, uses stdin as input. 
    Each file given as arg is converted to stdout.

Standard color codes must be defined in conky's configuration as such:
    color0 = 'Black'
    color1 = 'Red',
    color2 = 'Green',
    color3 = 'Yellow',
    color4 = 'Blue',
    color5 = 'Magenta',
    color6 = 'Cyan',
    color7 = 'White'
"""

import sys
import re

def eightbit_to_conky(color_code: int) -> str:
    """Converts the 8-bit code (having followed ESC[xx38;5;)
    
    Arg:
        color_code : the code extracted from CSI sequence ESC[38;5;(n)m
    
    Returns:
        (str) the $color command to add to conky.text
    """

    if color_code>=0 and color_code<8: # standard colors
        return conky_set_fg(color_code) # treat as set fg
    elif color_code>7 and color_code<16: #highlight colors
        return conky_set_fg(color_code-8) # treat as set fg
    elif color_code>15 and color_code<232: # 216 colors encoded
        # extract the 3 elements (value 0 to 5)
        color_code -= 16
        red   = color_code // 36 ; color_code %= 36
        green = color_code // 6
        blue  = color_code % 6
        
        # convert values 0-5 to their equivalent in RGB color code #00-FF
        to_FF=('00', '5F', '87', 'AF', 'D7', 'FF')  # values taken from the table at https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
        return '${color #' + to_FF[red] + to_FF[green] + to_FF[blue] + '}'
    elif color_code>231 and color_code<256: # grayscale from black to white in 24 steps
        sat=format(8+(color_code-232)*10, '02X')
        return f'${{color #{sat}{sat}{sat}}}'
    else: # >255 unexpected
        raise ValueError(f'Improper value {color_code} after 38;5')

def conky_set_fg(code: int) -> str:
    """Returns the instruction in conky to set foreground color to X"""
    return f'${{color{code}}}'

def csi_to_conky(match: re.Match) -> str:
    """Converts the received ansi code to conky code ${color}

    This function must be called as repl in re.sub(pattern, repl, string) for instance.
        The pattern parameter must match the whole ANSI sequence, and capture one group which is the list of parametres between [ and m].
        
    Example:
        converted=re.sub('\x1b\[([0-9;]*)m', csi_to_conky, original)

    Args:
        match (re.Match): the matched object

    Returns:
        (str) the string that will replace the pattern
    
    """
    # Convert the string of code;code;code to a list of ints
    try:
        codes= [0 if _=='' else int(_) for _ in match.group(1).split(';')]
    except IndexError: 
        print('csi_to_conky called with no group match', file=sys.stderr)
        return match.group(0) # if no group has matched return the string as is
    except ValueError as err: # problem converting to int
        print(f'csi_to_conky: {err}', file=sys.stderr)
        return match.group(0)
    
    # Initialize the string to be returned
    result=''

    # consume the list one code at a time, first to last
    while len(codes)>0:
        code=codes.pop(0)
        if code==0: # Reset
            # Clear the string and init it with default color and font
            result = '${color}${font}'
            continue
        
        elif code==1: # Bold
            result += '${font DejaVu Sans Mono:style=bold}'
            continue
        
        elif code>29 and code<38: # Set foreground color (0 to 7)
            result += conky_set_fg(code -30)
            continue
        
        elif code==38: # Advanced ANSI
            try:
                type=codes.pop(0)
                if type==2: # ESC[38;2;R;G;Bm => TODO
                    # for now just consume the next 3 values in the list
                    del codes[0:3]
                    continue
                elif type==5: # ESC[38;5;xxm 
                    result += eightbit_to_conky(codes.pop(0))
                    continue
                else:
                    raise ValueError(f'Improper value {type} after code 38')
            except (IndexError, ValueError) as err:
                print(f'csi_to_conky: {err} while parsing advanced ANSI sequence {code};{type}', file=sys.stderr)
                continue
        
        elif code==39: # default fg
            result +='${color}'
            continue
        
        else:
            print(f'code {code} not implemented', file=sys.stderr)
            continue 

    return result

def substitute(line:str) -> str:
    """Called for each line of each input file.
    
    Extracts ANSI codes from line and substitutes them with color commands.

    Args:
        line (str): string containing ANSI color codes to convert

    Returns:
        str: the string with codes converted to color commands.
    """
    to_replace=( 
        (r'\$', '$$'),                      # replace $ with $$ to prevent interpretation by conky
        (r'#', '\#'),                       # replace # with \# 
        (r'\x1b\[([0-9;]*)m', csi_to_conky),# ESC[(x;y;z;...)m => CSI code  to convert
    )
    for (pattern, repl) in to_replace:
        line=re.sub(pattern, repl, line)
        
    return line

def process(file):
    for line in file:
        line=line.rstrip('\n')
        print(substitute(line))

def main():
    filenames=sys.argv[1:] or ('-')
    
    for filename in filenames:
        if filename == '-':
            process(sys.stdin)
            continue
        
        with open(filename, 'r') as file:
            process(file)

if __name__ == '__main__':
    main()