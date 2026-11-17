import jax
import jax.numpy as jnp
from flatppl import flatppl

source = '''flatppl_compat = "0.1"
x = elementof(reals)
mu = elementof(reals)
inputs = (x, mu)
outputs = logdensityof(Normal(mu, 1.0), x)
'''
model = flatppl(source)
score = model.compile()

value = score(x=1.0, mu=0.0)
print(float(value))

gradient = jax.value_and_grad(score, argnums=0)
value, dx = jax.jit(gradient)(1.0, 0.0)
print(float(dx))

xs = jnp.array([-1.0, 0.0, 1.0])
batch = jax.vmap(score, in_axes=(0, None))
print(batch(xs, 0.0))
