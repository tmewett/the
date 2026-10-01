import os.path
from dataclasses import dataclass
from pathlib import Path
from typing import Any

@dataclass
class BuildContext:
    targets: Any = None

@dataclass
class ActionContext:
    output: Any

@dataclass
class Target:
    output_name: Any
    function: Any

def touch(acx):
    with acx.output.open("w"):
        pass

def run(define_build):
    build_dir = Path("anvil-build")
    bcx = BuildContext()
    define_build(bcx)
    for t in bcx.targets:
        module, var = t.function.rsplit(".", maxsplit=1)
        output_path = build_dir / "out" / t.output_name
        output_path.parent.mkdir(parents=True)
        acx = ActionContext(output_path)
        getattr(__import__(module), var)(acx)
