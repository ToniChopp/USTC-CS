import numpy as np


class ID3:
    def Query(self, rows, col, col_v):
        result = []
        for i in range(len(self.train_data)):
            if rows[i] and self.train_data[i, col] == col_v:
                result.append(True)
            else:
                result.append(False)
        return np.array(result)

    def Select_Attribute(self, data_index, attri_index):
        D = len(data_index)
        cnt_p = np.bincount(np.squeeze(
            self.train_label[data_index, :]))  # 统计训练结果中0, 1个数
        p = cnt_p / D  # 概率
        ent_d = Entropy(p)  # 计算信息熵
        gain = []
        for i in attri_index:  # 对每个属性计算信息熵，然后计算信息增益
            gain_tmp = 0
            for v in range(np.max(self.train_data[:, i]) + 1):
                v_label = self.train_label[self.Query(data_index, i, v), :]
                D_v = len(v_label)
                if D_v == 0:
                    continue
                cnt_p_v = np.bincount(np.squeeze(v_label, 1))
                p_v = cnt_p_v / D_v
                ent_d_v = Entropy(p_v)
                gain_tmp += D_v / D * ent_d_v
            gain.append(ent_d - gain_tmp)
        gain = np.array(gain)
        return attri_index[np.argmax(gain)]  # 返回最大信息增益的属性

    def Tree_Generate(self, data_index, attri_index):
        if np.max(self.train_label[data_index, :]) == np.min(
                self.train_label[data_index, :]):  # 当前数据的所有类别都相同，返回这个类别
            return int(self.train_label[data_index][0][0])
        if len(attri_index) == 0 or Check_equ(self.train_data[
                data_index, :][:, attri_index]):  # 当前所有的属性值都相同，返回这些行中数量最多的类别
            return int(
                np.argmax(
                    np.bincount(np.squeeze(self.train_label[data_index, :], 1))))
        node = {}
        select_attr = self.Select_Attribute(data_index, attri_index)  # 通过信息增益选择出来的属性
        left_attrs = [a for a in attri_index if a != select_attr]     # 剩余属性
        for v in range(np.max(self.train_data[:, select_attr]) + 1):     # 对属性值域遍历
            if len(self.train_label[self.Query(data_index, select_attr, v), :]) == 0:  # 若这个值不对应任何样本，就返回所有训练集中数量最多的种类
                node[str(select_attr) + '-' + str(v)] = int(np.argmax(np.bincount(
                    np.squeeze(self.train_label[data_index, :], 1))))
            else:
                child = self.Tree_Generate(
                    self.Query(data_index, select_attr, v), left_attrs)     # 递归调用
                node[str(select_attr) + '-' + str(v)] = child
        return node

    def Fit(self, train_data, train_label):
        self.train_data = train_data.copy()
        self.train_label = train_label.copy()
        m, n = self.train_data.shape  # 训练数据规模
        self.tree = self.Tree_Generate(np.array([True] * m),
                                       list(range(n)))  # 建造决策树

    def Predict(self, test_data):
        self.test_data = test_data.copy()
        result = []
        for line in self.test_data:
            n = self.tree
            while not isinstance(n, int):                  # 若遍历到的对象不是整型（⾮叶节点），则继续遍历
                attr = int(list(n.keys())[0].split('-')[0])    # 根据属性名核属性值，构成查询的key，在字典中找到正确的分⽀
                val = line[attr]
                n = n[str(attr) + '-' + str(val)]
            result.append([n])
        return np.array(result)

    def __init__(self):
        self.train_data = None
        self.train_label = None
        self.tree = {}
        self.test_data = None


def Entropy(p):  # 计算熵
    ent_d = 0
    for p_k in p:
        if p_k == 0:
            ent_d += 0
        else:
            ent_d += p_k * np.log2(p_k)
    return -ent_d


def Check_equ(a):  # 数组每一维全相同返回 True，用以建树时检查属性
    flag = True
    for line in a:
        if list(line) != list(a[0, :]):
            flag = False
            break
    return flag
