import numpy as np

def hamiltonian_dynamics(current_state, current_velocity, stepsize, num_steps, gradlogdensity):
    x = current_state
    v = current_velocity
    """Simulate Hamiltonian dynamics."""    
    v = v + stepsize * np.array(gradlogdensity(x)) / 2
    for step in range(num_steps):
      x = x + stepsize * v
      if step != (num_steps-1):
        v = v + stepsize * np.array(gradlogdensity(x))
    v = v + stepsize * np.array(gradlogdensity(x)) / 2    
    return (x, v)