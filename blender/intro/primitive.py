import bpy
from random import randint

def gen_monkeys():
    number = 60

    for i in range(60):
        x = randint(-30, 30)
        y = randint(-30, 30)
        z = randint(-30, 30)
        bpy.ops.mesh.primitive_monkey_add(location=(x,y,z))


if __name__ == "__main__":
    gen_monkeys()