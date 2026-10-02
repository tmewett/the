import os.path
from dataclasses import dataclass
from pathlib import Path
from typing import Any

class BuildContext:
    def __init__(self):
        self._products = {}
    def define(self, *args):
        p = Target(*args)
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
    def process(outp):
        non_source_inputs = [inp for inp in outp.inputs if isinstance(inp, Target)]
        deps_to_build[outp] = len(non_source_inputs)
        if not non_source_inputs:
            to_build.append(out)
            return
        for inp in non_source_inputs:
            if inp in rdeps[inp]:
                rdeps[inp].append(outp)
            else:
                rdeps[inp] = [outp]
            if inp not in deps_to_build:
                process(inp)
    targets = ["dep"]
    to_build = [bcx._products[target_name] for target_name in targets]
    while to_build:
        t = to_build.pop(0)
        module, var = t.function.rsplit(".", maxsplit=1)
        output_path = build_dir / "out" / t.output_name
        output_path.parent.mkdir(parents=True, exist_ok=True)
        acx = ActionContext(output_path)
        getattr(__import__(module), var)(acx)
        # for rd in rdeps:
        #     rd.deps_to_build -= 1
        #     if rd.deps_to_build == 0:
        #         to_build.append(rd)
