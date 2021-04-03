import numpy as np
import random


class KMeans:
    def GetDistance(self, x, y):
        return np.linalg.norm(x-y, ord=2)

    def Fit(self, train_data):
        self.train_data = train_data.copy()
        m = self.train_data.shape[0]
        centres = []
        for i in random.sample(range(m), self.K):                     # 在 m 个散点中随机选择 K 个作为聚类中心点
            centres.append(list(np.squeeze(np.array(self.train_data[i, :]))))
        centres = np.mat(centres)
        distance = 10000
        label = []
        if distance > self.threshold:                        # 迭代，直到聚类中心点位置变化小于阈值
            centres_old = centres.copy()
            for i in range(m):
                label_min = -1
                distance_min = 10000
                for j in range(self.K):
                    distance_ij = self.GetDistance(self.train_data[i], centres[j])
                    if distance_ij < distance_min:           # 标注数据点到 j 类中心的距离
                        distance_min = distance_ij
                        label_min = j
                label.append(label_min)                      # 完成一个分类
            label = np.array(label)
            centres = np.array([np.mean(self.train_data[label == i, :], axis=0) for i in range(self.K)])
            centres = np.mat(np.squeeze(centres))            # 更新聚类中心
            distance = np.sum(np.linalg.norm(centres-centres_old, ord=2, axis=1))        # 聚类中心变化的距离
        return centres, np.expand_dims(label, 1)

    def Evaluate(self, train_data, train_label, predict_label, K):           # 计算兰德系数与轮廓系数
        self.train_data = train_data.copy()
        self.train_label = train_label.copy()
        self.predict_label = predict_label.copy()
        self.K = K
        assert train_label.shape == predict_label.shape
        a, b, c, d = 0, 0, 0, 0
        for i in range(len(train_label)):                             # 兰德系数
            for j in range(i+1, len(train_label)):
                if i == j:
                    continue
                if train_label[i][0] == train_label[j][0] and predict_label[i][0] == predict_label[j][0]:
                    a += 1
                elif train_label[i][0] == train_label[j][0] and predict_label[i][0] != predict_label[j][0]:
                    b += 1
                elif train_label[i][0] != train_label[j][0] and predict_label[i][0] == predict_label[j][0]:
                    c += 1
                elif train_label[i][0] != train_label[j][0] and predict_label[i][0] != predict_label[j][0]:
                    d += 1
        S = []                                         # 轮廓系数
        for i in range(len(train_label)):
            dis = [[] for j in range(self.K)]
            class_i = predict_label[i][0]
            for j in range(len(train_label)):
                if i == j:
                    continue
                dis[predict_label[j][0]].append(np.linalg.norm(train_data[i, :] - train_data[j, :], ord=2))
            a_i = np.mean(dis[class_i])
            b_i = min([np.mean(dis[j]) for j in range(K) if j != class_i])           # 这里当做平均值的最小值理解
            S.append((b_i - a_i) / max(a_i, b_i))
        return{
            'RI': (a + d) / (a + b + c + d),
            'S': np.mean(np.array(S))
        }

    def __init__(self, K=3, train_data=None, train_data_handled=None, train_label=None, threshold=0.8):
        self.K = K
        self.train_data = None
        self.train_data_handled = None
        self.train_label = None
        self.predict_label = None
        self.threshold = threshold
