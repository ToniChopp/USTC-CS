import numpy as np

def data_generation(N, w, std = 0.1):               # Generate a dataset (X,Y) where Y = Xw + e and e is Gaussian with standard deviation = std
    X = np.random.rand(N,2)*2-1
    err_set = np.random.randn(N,1)*std
    Y = np.dot(X, w) + err_set
    Y = np.clip(Y, -1., 1.)
    return (X, Y)

def L2_loss(X, Y, w):
    tmp = np.dot(X, w) - Y
    return np.dot(tmp.T, tmp)

def sigmasq_func(eps, delta, sens = 1.):            # Compute the variance for a (eps, delta)-DP Gaussian mechanism with sensitivity = sens
    return 2.*np.log(1.25/delta)*sens**2/(eps**2)

def comp_reverse(eps, delta, T):                    # Given the privacy parameter of the composed mechanism, compute the privacy parameter of each sub-mechanism (by either composition or advanced composition)
    # *to do: Advanced composition can be applied (not required)
    return eps/T, delta/T

def LR_GD(X, Y, eps, delta, T, C = 1., eta = 0.1):  # Solve the Linear regression with (eps, delta)-differentially private SGD
    N, d = X.shape                                  # Get the dimension of X, here d = 2
    w = np.zeros((d,1))
    eps_u, delta_u = comp_reverse(eps, delta, T)    # Compute the privacy parameter of each update, (eps_u, delta_u), given (eps, delta, T)
    sigmasq = sigmasq_func(eps_u, delta_u)          # Compute the variance when sensitivity = 1
    for i in range(T):
        tmp = np.dot(X,w)-Y
        gradient = 2*np.dot(X.T, tmp)               # Compute the gradient
        # to do: Clip gradient
        # to do: Add noise
        # to do: Gradient decent
        gradived = np.linalg.norm(gradient, ord=2, axis=None, keepdims=False)
        gradived /= C
        if gradived >= 1:
            gradient /= gradived
        else:
            gradient /= 1
        noise = np.random.randn(d, 1)
        noise *= (np.sqrt(sigmasq) * C)
        gradient += noise
        gradient_hat = gradient / N
        w -= eta * gradient_hat
    return w

def LR_FM(X, Y, eps, delta):
    N, d = X.shape                                  # Get the dimension of X, here d = 2
    sens = 2.*(1+d)**2
    sigmasq = sigmasq_func(eps, delta, sens)        # Variance in Functional Mechanism
    noise_1 = np.random.randn(d,d)
    noise_1 *= np.sqrt(sigmasq)/2.
    noise_1 = np.triu(noise_1)
    noise_1 = noise_1 + noise_1.T                   # Compute the noise matrix for X^T*X
    noise_2 = np.random.randn(d,1)
    noise_2 *= np.sqrt(sigmasq)/2.                     # Compute the noise matrix for X^T*Y
    Phi = np.dot(X.T, X)                            # Phi = X^T * X
    Phi_hat = Phi + noise_1
    # to do: Phi_hat can be modified approximately 
	# (e.g. Add 4*sigma*I to it, where I is the 
	# identity matrix)
    XY = np.dot(X.T, Y)
    XY_hat = XY + noise_2
    tmp = np.linalg.inv(Phi_hat)
    w = np.dot(tmp, XY_hat)                         # w = (X^T*X)^(-1) * X^TY
    return w

if (__name__=='__main__'):
    eps, delta = 1.25, 10**(-3)                     # parameters for DP
    N, T = 100, 100
    w = np.array([[0.5],[0.5]])                     # parameters for LR
    X, Y = data_generation(N, w)                    # generate the training data
    w = LR_GD(X, Y, eps, delta, T)
    print(L2_loss(X, Y, w))
    w = LR_FM(X, Y, eps, delta)
    print(L2_loss(X, Y, w))