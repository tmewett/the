import anvil

def rev(acx):
    s = acx.inputs["msg"].read_text()
    acx.output.write_text(s[::-1])

def define_build(bcx):
    bcx.define(
        "msg.rev",
        rev,
        inputs=["msg"],
    )

anvil.run(define_build)
