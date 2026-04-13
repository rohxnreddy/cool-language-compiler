import sys
import re


def execute_tac(tac_text):
    lines = [line.strip() for line in tac_text.strip().split("\n") if line.strip()]
    labels = {}
    instructions = []
    current_instr_idx = 0

    for line in lines:
        if line.endswith(":"):
            labels[line[:-1]] = current_instr_idx
        else:
            instructions.append(line)
            current_instr_idx += 1

    vars = {}
    ip = 0
    while ip < len(instructions):
        line = instructions[ip]

        if line.startswith("ifFalse"):
            match = re.match(r"ifFalse (.*) goto (.*)", line)
            if match:
                cond_var, target_label = match.groups()
                if not vars.get(cond_var, False):
                    ip = labels[target_label]
                    continue

        elif line.startswith("goto"):
            target_label = line.split()[1]
            ip = labels[target_label]
            continue

        elif "=" in line:
            # Only split on the first '=' to avoid issues with '<='
            target, expr = [x.strip() for x in line.split("=", 1)]

            # Add "<=" to the detection list
            if any(op in expr for op in ["+", "-", "<=", "<"]):
                parts = expr.split()
                left = vars.get(
                    parts[0], int(parts[0]) if parts[0].lstrip("-").isdigit() else 0
                )
                op = parts[1]
                right = vars.get(
                    parts[2], int(parts[2]) if parts[2].lstrip("-").isdigit() else 0
                )

                if op == "+":
                    vars[target] = left + right
                elif op == "-":
                    vars[target] = left - right
                elif op == "<=":  # New logic for <=
                    vars[target] = left <= right
                elif op == "<":
                    vars[target] = left < right
            else:
                vars[target] = vars.get(
                    expr, int(expr) if expr.lstrip("-").isdigit() else 0
                )
        ip += 1
    return vars


if __name__ == "__main__":
    # Check if data is being piped in
    if not sys.stdin.isatty():
        input_data = sys.stdin.read()
    else:
        print("No piped input detected. Usage: cat file.txt | python script.py")
        sys.exit(1)

    if input_data:
        final_variables = execute_tac(input_data)
        for var, val in sorted(final_variables.items()):
            print(f"{var} = {val}")
