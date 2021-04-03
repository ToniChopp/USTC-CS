import numpy as np
import pandas as pd
from sklearn import preprocessing

from SVM import SVM
from KNN import KNN
from ID3 import ID3


def LoadandHandle_inputData(direction,
                            src_column=['G1', 'G2'],
                            dest_column='G3',
                            rate=0.7):
    data_input = pd.read_csv(direction, sep=';')
    tmp = np.array(data_input['absences'])  # 对缺课次数，分为4类
    ab0 = tmp <= 5
    tmp[ab0] = 0
    ab1 = (tmp > 5) & (tmp <= 10)
    tmp[ab1] = 1
    ab2 = (tmp > 10) & (tmp < 20)
    tmp[ab2] = 2
    ab3 = (tmp > 20)
    tmp[ab3] = 3
    data_input['absences'] = tmp
    tmp = np.array(data_input['G1'])  # 成绩，1：合格，0：不合格
    uqlf = tmp < 10
    qlfy = tmp >= 10
    tmp[uqlf] = 0
    tmp[qlfy] = 1
    data_input['G1'] = tmp
    tmp = np.array(data_input['G2'])
    uqlf = tmp < 10
    qlfy = tmp >= 10
    tmp[uqlf] = 0
    tmp[qlfy] = 1
    data_input['G2'] = tmp
    tmp = np.array(data_input[dest_column])
    uqlf = tmp < 10
    qlfy = tmp >= 10
    tmp[uqlf] = 0
    tmp[qlfy] = 1
    data_input[dest_column] = tmp
    for i in data_input.columns:  # 用 LabelEncoder 转化
        temp = np.array(data_input[i])
        if isinstance(temp[0], str):
            le = preprocessing.LabelEncoder()
            le.fit(temp)
            data_input[i] = le.transform(data_input[i])
    if src_column is not None:
        data_arg = data_input[data_input.columns.difference(
            [dest_column])][src_column].copy()  # 除了G3外的所有数据
    else:
        data_arg = data_input[data_input.columns.difference([dest_column
                                                             ])].copy()
    data_rst = data_input[dest_column].copy()  # G3
    index = np.arange(len(data_input))  # 随机选择 7:3 的训练测试集
    np.random.shuffle(index)
    index_train = index[:int(rate * len(index))]
    index_test = index[int(rate * len(index)):]

    train_arg = np.array(data_arg).copy()[index_train]  # 训练数据集
    train_rst = np.array(data_rst).copy()[index_train]  # 训练结果
    test_arg = np.array(data_arg).copy()[index_test]  # 测试数据集
    test_rst = np.array(data_rst).copy()[index_test]  # 测试结果
    train_arg_return = train_arg.copy()
    train_rst_return = train_rst.reshape(len(train_rst), -1)
    test_arg_return = test_arg.copy()
    test_rst_return = test_rst.reshape(len(test_rst), -1)
    return train_arg_return, train_rst_return, test_arg_return, test_rst_return


def Evaluate(test_y, predict_y):
    assert test_y.shape == predict_y.shape
    TP, FP, TN, FN = 0, 0, 0, 0
    for i in range(len(test_y)):
        if test_y[i][0] == 0 and predict_y[i][0] == 0:
            TN += 1
        elif test_y[i][0] == 1 and predict_y[i][0] == 1:
            TP += 1
        elif test_y[i][0] == 1 and predict_y[i][0] == 0:
            FN += 1
        elif test_y[i][0] == 0 and predict_y[i][0] == 1:
            FP += 1
    if (TP + FP) == 0:
        print("Error:can't calculate P")
        exit(3)
    if (TP + FN) == 0:
        print("Error:Can't calculate R")
        exit(3)
    P = TP / (TP + FP)
    R = TP / (TP + FN)
    F1 = (2 * P * R) / (P + R)
    return {
        'TP': TP,
        'FP': FP,
        'TN': TN,
        'FN': FN,
        'P': P,
        'R': R,
        'F1': F1,
    }


def main():
    dataset_direction = "../data/student-por.csv"
    columns = [
        'school', 'sex', 'age', 'address', 'famsize', 'Pstatus', 'Medu',
        'Fedu', 'Mjob', 'Fjob', 'reason', 'guardian', 'traveltime',
        'studytime', 'failures', 'schoolsup', 'famsup', 'paid', 'activities',
        'nursery', 'higher', 'internet', 'romantic', 'famrel', 'freetime',
        'goout', 'Dalc', 'Walc', 'health', 'absences', 'G1', 'G2'
    ]
    train_arg, train_rst, test_arg, test_rst = LoadandHandle_inputData(
        direction=dataset_direction, src_column=columns)

    # KNN
    classifier = KNN(K=30)
    classifier.Fit(train_arg, train_rst)
    predict_rst = classifier.Predict(test_arg)
    result = Evaluate(test_rst, predict_rst)
    print("KNN:", result)

    # SVM
    classifier = SVM(C=0.5, kernel='RBF_Gauss', sigma=0.5)
    classifier.Fit(train_arg, train_rst)
    predict_rst = classifier.Predict(test_arg)
    result = Evaluate(test_rst, predict_rst)
    print("SVM:", result)

    # ID3
    classifier = ID3()
    classifier.Fit(train_arg, train_rst)
    print("tree:", classifier.tree)
    predict_rst = classifier.Predict(test_arg)
    result = Evaluate(test_rst, predict_rst)
    print("ID3:", result)


if __name__ == "__main__":
    main()
