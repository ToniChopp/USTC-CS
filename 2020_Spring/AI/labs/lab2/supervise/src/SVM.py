import numpy as np
import random


class SVM:
    class SMO:
        def SatisfyKKT(self, alpha, label, F, epsilon=0.1):  # 满足 KKT 条件判别
            if (label * F) < -epsilon and alpha < self.C:
                return False
            if (label * F) > epsilon and alpha > 0:
                return False
            else:
                return True

        def Train(self, max_iteration=40):
            dataNumber = self.data.shape[0]
            alphas = np.zeros((dataNumber, 1), dtype=float)
            bias = 0.0
            E = np.zeros((dataNumber, 1), dtype=float)
            epsilon = 0.000001  # epsilon 在迭代中累加
            times = 0
            while (times < max_iteration):
                flag = False
                for i in range(dataNumber):
                    E[i] = np.sum(alphas * self.label * self.K.KernelMatrix[:, i].reshape(-1, 1))\
                        + bias - self.label[i]
                    if not self.SatisfyKKT(alphas[i], self.label[i], E[i],
                                           epsilon):  # alpha 取值不满足 KKT
                        j = random.randint(0, dataNumber - 1)  # 重新随机生成一个 alpha
                        while j == i:
                            j = random.randint(0, dataNumber - 1)
                        alpha_i = alphas[i][0]
                        alpha_j = alphas[j][0]
                        if self.label[i] == self.label[j]:  # 计算 L H
                            L = max(0, alphas[j] + alphas[i] - self.C)
                            H = min(self.C, alphas[j] + alphas[i])
                        else:
                            L = max(0, alphas[j] - alphas[i])
                            H = min(self.C, self.C + alphas[j] - alphas[i])
                        if L == H:      # alpha_i 无法最优
                            continue
                        eta = 2 * self.K.KernelMatrix[i, j] - self.K.KernelMatrix[i, i]\
                            - self.K.KernelMatrix[j, j]              # 计算 eta
                        if eta >= 0:    # alpha_i 无法得到最优
                            continue
                        alphas[j] = alphas[j] - self.label[j] * (E[i] - E[j]) / eta     # 更新 alpha_j 的值
                        if alphas[j] > H:
                            alphas[j] = H
                        elif alphas[j] < L:
                            alphas[j] = L
                        if np.abs(alphas[j] - alpha_j) < epsilon:       # alpha_j 的值变化小于 epsilon 则忽略
                            alphas[j] = alpha_j
                            continue
                        alphas[i] = alphas[i] + self.label[i] * self.label[j]\
                            * (alpha_j - alphas[j])        # 更新 alpha_i
                        b1 = bias - E[i] - self.label[i] * (alphas[i] - alpha_i) * self.K.KernelMatrix[i, j]\
                            - self.label[j] * (alphas[j] - alpha_j) * self.K.KernelMatrix[i, j]   # 更新 bias
                        b2 = bias - E[j] - self.label[i] * (alphas[i] - alpha_i) * self.K.KernelMatrix[i, j]\
                            - self.label[j] * (alphas[j] - alpha_j) * self.K.KernelMatrix[j, j]
                        if 0 < alphas[i] < self.C:         # 根据 alpha_i 与 alpha_j 的值选择更新后 bias 的值
                            bias = b1
                        elif 0 < alphas[j] < self.C:
                            bias = b2
                        else:
                            bias = (b1 + b2) / 2
                        flag = True
                if flag:
                    times = 0
                else:
                    times += 1
            chosen = alphas > 0
            support_vector = self.data[chosen.reshape(1, -1)[0], :]
            corre_label = self.label[chosen.reshape(1, -1)[0]]
            corre_alphas = alphas[chosen.reshape(1, -1)[0]]
            weight = ((alphas * self.label).T @ self.data).T
            return support_vector, corre_label, corre_alphas, bias, weight

        def __init__(self, data, label, KernelMatrix, C):
            self.data = data
            self.label = label
            self.C = C
            self.K = KernelMatrix

    class KernelFunction:
        def Linear(self, X):                             # 线性核
            return np.dot(X, X.T)

        def RBF_Gauss(self, X, sigma):                   # 高斯核
            Xsq = np.sum(np.power(X, 2), axis=1).reshape(-1, 1)
            result = Xsq - 2 * (np.dot(X, X.T)) + Xsq.T
            result = np.exp(-result / (2 * sigma * sigma))
            return result

        def __init__(self, kernel, X, d=3, sigma=5, beta=1, theta=-1):
            if kernel == 'Linear':
                self.KernelMatrix = self.Linear(X)
            elif kernel == 'RBF_Gauss':
                self.KernelMatrix = self.RBF_Gauss(X, sigma)
            else:
                print('No such kernel function')
                exit(3)

    def Fit(self, data, label):
        self.data = data.copy()
        self.label = label.copy()
        self.alphas = np.zeros((data.shape[0], 1), dtype=float)
        KernelFunction = self.KernelFunction(self.kerner, self.data)
        smo = self.SMO(self.data, self.label, KernelFunction, self.C)
        self.sv, self.cl, self.alphas, self.bias, self.weight = smo.Train(max_iteration=3)

    def Predict(self, data):
        dataNumber = data.shape[0]
        Y = np.array([])
        prediction = np.zeros((dataNumber, 1))
        if self.kerner == 'Linear':
            Y = np.sum(data @ self.weight + self.bias)
        elif self.kerner == 'RBF_Gauss':
            Xsq = np.sum(np.power(data, 2), axis=1).reshape(-1, 1)
            SVsq = (np.sum(np.power(self.sv, 2), axis=1)).T
            K = Xsq - 2 * (data @ (self.sv).T) + SVsq.T
            K = np.exp(-K / (2 * self.sigma * self.sigma))
            K = self.cl.T * K
            K = self.alphas.T * K
            Y = np.sum(K, axis=1)
        prediction[Y >= 0] = 1
        prediction[Y < 0] = -1
        return np.array(prediction)

    def __init__(self, C=0.5, kernel='RBF_Gauss', cut=True, sigma=1):
        self.data = np.array([[]])
        self.label = np.array([[]])
        self.C = C
        self.kerner = kernel
        self.sv = np.array([])
        self.cl = np.array([])
        self.alphas = np.array([])
        self.bias = -1
        self.weight = np.array([])
        self.sigma = sigma
