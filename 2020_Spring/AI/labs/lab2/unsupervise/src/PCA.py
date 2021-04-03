import numpy as np


class PCA:
    def Fit(self, train_data):
        self.train_data_T = np.mat(train_data.copy()).T  # 转置成 n 行 m 列
        train_data_T_mean = np.mean(self.train_data_T, axis=1)    # 零均值化
        train_data_T_delta = self.train_data_T - np.tile(train_data_T_mean, self.train_data_T.shape[1])
        train_data_T_cov = train_data_T_delta * train_data_T_delta.T      # 协方差矩阵
        eigen_val, eigen_vec = np.linalg.eig(train_data_T_cov)            # 计算你特征值特征向量
        zipped = sorted(zip(eigen_val, eigen_vec.T), reverse=True)        # 将特征向量按对应特征值大小从上到下按行排列成矩阵
        eigen_val, eigen_vec = zip(*zipped)

        if self.flag is True:
            sum_eigen_val = sum(eigen_val)             # 通过累计贡献率来得到 m
            cnt = 0
            vector = []
            for i in range(len(eigen_val)):
                cnt += eigen_val[i]
                vector.append(list(np.squeeze(np.array(eigen_vec[i]))))      # 得到的前 m 个特征向量
                if cnt / sum_eigen_val >= self.threshold:
                    break
        else:                                 # 降维成指定规模
            vector = [list(np.squeeze(np.array(eigen_vec[i]))) for i in range(self.K)]

        self.vector = np.mat(np.array(vector)).T
        self.train_data_T_mean = train_data_T_mean
        mat_return = self.train_data_T.T * self.vector         # 返回的降维后的矩阵
        print('Get', mat_return.shape[1], 'principal components')
        return mat_return

    def __init__(self, train_data, threshold=0.8, flag=True, K=3):
        self.train_data_T = None
        self.threshold = threshold
        self.flag = flag
        self.K = K
        self.train_data_T_mean = None
        self.vector = None
