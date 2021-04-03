import numpy as np


class KNN:
    def Fit(self, data, label):
        self.data = data.copy()
        self.label = label.copy()

    def Predict(self, test_data):
        prediction = []
        for test_data in test_data:
            # 计算距离
            distances = []
            for index, train_data in enumerate(self.data):
                distance = 0
                for title in range(len(train_data)):
                    distance += (test_data[title] - train_data[title])**2
                distances.append([distance, self.label[index]])
            distances.sort()
            # 通过距离做出预测
            pass_cnt = 0
            for index, element in enumerate(distances):
                if index == self.K:
                    break
                if element[1] == 1:
                    pass_cnt += 1
            if pass_cnt >= self.K / 2:
                prediction.append(1)
            else:
                prediction.append(0)
        return np.array(prediction).reshape(len(prediction), -1)

    def __init__(self, K=10):
        self.data = []
        self.label = []
        self.K = K
