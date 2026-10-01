import anvil

def define_build(bcx):
    hello = anvil.Target(
        "hello",
        "anvil.touch",
    )
    bcx.targets = [hello]

anvil.run(define_build)
