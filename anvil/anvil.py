import os.path
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any

class BuildContext:
    def __init__(self):
        self._products = {}
    def define(self, *args, **kwargs):
        p = Target(*args, **kwargs)
        self._products[p.output_name] = p

@dataclass
class ActionContext:
    output: Any

@dataclass
class Target:
    output_name: Any
    function: Any
    inputs: Any = ()

def touch(acx):
    with acx.output.open("w"):
        pass

def run(define_build):
    build_dir = Path("anvil-build")
    bcx = BuildContext()
    define_build(bcx)
    deps_to_build = {}
    rdeps = defaultdict(lambda: [])
    to_build = []
    def process(outp):
        non_source_inputs = [bcx._products[inp_name] for inp_name in outp.inputs if inp_name in bcx._products]
        deps_to_build[id(outp)] = len(non_source_inputs)
        if not non_source_inputs:
            to_build.append(outp)
            return
        for inp in non_source_inputs:
            rdeps[id(inp)].append(outp)
            if id(inp) not in deps_to_build:
                process(inp)
    process(bcx._products["hello"])
    while to_build:
        t = to_build.pop(0)
        print(t)
        module, var = t.function.rsplit(".", maxsplit=1)
        output_path = build_dir / "out" / t.output_name
        output_path.parent.mkdir(parents=True, exist_ok=True)
        acx = ActionContext(output_path)
        getattr(__import__(module), var)(acx)
        for rd in rdeps[id(t)]:
            deps_to_build[id(rd)] -= 1
            if deps_to_build[id(rd)] == 0:
                to_build.append(rd)
