import anvil

def define_build(bcx):
    sources = []

    executable(bcx, "brogue", sources)

anvil.run(define_build)
