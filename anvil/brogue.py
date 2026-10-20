import anvil

def define_build(bcx):
    sdl_cflags_p = subprocess.run(["sdl2-config", "--cflags"], check=True)
    sdl_libs_p = subprocess.run(["sdl2-config", "--libs"], check=True)

    object_from_c(bcx, "", include=["src/h"])
    executable(bcx, "brogue", sources, flags=sdl_cflags)

anvil.run(define_build)
