from pathlib import Path

import jax
import jax.numpy as jnp
from flatppl import load

path = Path(__file__).with_name("score.flatppl")
model = load(path)
score = model.compile()

value = score(x=1.0, mu=0.0)
print(float(value))

gradient = jax.value_and_grad(score, argnums=0)
value, dx = jax.jit(gradient)(1.0, 0.0)
print(float(dx))

xs = jnp.array([-1.0, 0.0, 1.0])
batch = jax.vmap(score, in_axes=(0, None))
print(batch(xs, 0.0))
