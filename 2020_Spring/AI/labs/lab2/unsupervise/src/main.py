import numpy as np
import pandas as pd
from matplotlib import pyplot
from mpl_toolkits.mplot3d import Axes3D

from PCA import PCA
from KMeans import KMeans


def LoadandHandle_InputData(direction, random=False, handle=True):
    file = open(direction, 'r')
    datas = np.array([[]])
    train_data = np.array([[]])
    train_label = np.array([])
    for data in file:
        data = data.split(',')
        if datas.size == 0:
            datas = np.array([data])
        else:
            datas = np.append(datas, [data], axis=0)
        if train_label.size == 0:
            train_label = np.array(data[0])
        else:
            train_label = np.append(train_label, [data[0]])
        if train_data.size == 0:
            train_data = np.array([data[1:]])
        else:
            train_data = np.append(train_data, [data[1:]], axis=0)
    train_data = train_data.astype('float')
    train_label = train_label.astype('int')
    datas = datas.astype('float')
    for i in range(len(datas)):
        datas[i][0] -= 1
    train_label -= np.min(train_label)
    if handle:  # 数据缩放，将 data 的每一元减去平均值再除以标准差（类似正态分布）
        for i in range(train_data.shape[1]):
            train_data[:, i] = (train_data[:, i] - np.mean(
                train_data[:, i])) / np.std(train_data[:, i])
    train_data_return = train_data.reshape(len(train_data), -1)
    train_label_return = train_label.reshape(len(train_label), -1)
    return train_data_return, train_label_return, datas


def Save_Data(data, label):
    class_num = np.max(label)
    for i in range(class_num + 1):
        save = []  # 将要被存储的 list
        for j in range(len(data)):
            if i == label[j][0]:  # 第 j 个数据在第 i 类
                save.append(data[j])  # 存入待存储的 list
        pd_data = pd.DataFrame(np.array(save))
        pd_data.to_csv('../output/第%d类.csv' % i, index=False)


def Visiable(centres, data, label, dimension):
    colours = ['violet', 'orange', 'lightblue']
    if dimension == 2:  # 二维可视
        for i in range(len(data)):
            pyplot.scatter(data[i, 0], data[i, 1], c=colours[label[i][0]])
        for i in range(len(centres)):
            pyplot.scatter(centres[i, 0], centres[i, 1], c='red', marker='*')
        pyplot.show()
    elif dimension == 3:  # 三维可视
        fig = pyplot.figure()
        ax = Axes3D(fig)
        for i in range(len(data)):
            ax.scatter(data[i, 0],
                       data[i, 1],
                       data[i, 2],
                       c=colours[label[i][0]])
        for i in range(len(centres)):
            ax.scatter(centres[i, 0],
                       centres[i, 1],
                       centres[i, 2],
                       c='red',
                       marker='*')
        pyplot.show()


def main():
    dataset_direction = "../input/wine.data"
    train_data, train_label, raw = LoadandHandle_InputData(
        dataset_direction, False, True)
    K = 3  # 降维与分类的 K 值
    dimension = 3  # 可视维度
    pca = PCA(train_data, threshold=0.9, flag=False, K=K)
    train_data_handled = pca.Fit(train_data)  # 降维后的数据
    kmeans = KMeans(K=K,
                    train_data=train_data,
                    train_data_handled=train_data_handled,
                    train_label=train_label,
                    threshold=0.01)
    centres, predict_label = kmeans.Fit(train_data_handled)
    result = kmeans.Evaluate(train_data, train_label, predict_label, K=K)
    Save_Data(raw, predict_label)
    print(result)
    Visiable(centres, train_data_handled, predict_label, dimension)


if __name__ == "__main__":
    main()
