from pathlib import Path

import jax
import numpy as np
import optimistix as optx
from flatppl import load

data = np.array([1.2, 0.4, 2.1, 1.7,
                 0.9, 1.5, 0.3, 1.1])
path = Path(__file__).with_name(
    "fitting-from-python.flatppl")
model = load(path).set(observed=data)

with jax.enable_x64(True):
    fit = model.logdensity("L", jacobian=False,
                           dtype="float64")
    def objective(z, args):
        return fit.potential(z)

    solver = optx.BFGS(rtol=1e-9, atol=1e-9)
    result = optx.minimise(objective, solver,
                           fit.init)
    point = fit.constrain(result.value)

print(float(point["mu"]), float(point["tau"]))
np.testing.assert_allclose(
    [point["mu"], point["tau"]],
    [data.mean(), 1 / data.var()], rtol=1e-7)
