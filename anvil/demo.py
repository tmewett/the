import anvil

def define_build(bcx):
    bcx.define(
        "dep",
        "anvil.touch",
    )
    bcx.define(
        "hello",
        "anvil.touch",
        inputs=["dep"],
    )

anvil.run(define_build)
