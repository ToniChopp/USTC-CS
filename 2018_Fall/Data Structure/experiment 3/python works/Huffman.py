import Tkinter as tk
import sys

window=tk.Tk()
window.title('Huffman Zipper')
window.geometry('500x400')


class HuffNode(object):

    def get_wieght(self):
        raise NotImplementedError(
            "The Abstract Node Class doesn't define 'get_wieght'")

    def isleaf(self):
        raise NotImplementedError(
            "The Abstract Node Class doesn't define 'isleaf'")


class LeafNode(HuffNode):


    def __init__(self, value=0, freq=0, ):
        super(LeafNode, self).__init__()
        # 节点的值
        self.value = value
        self.wieght = freq

    def isleaf(self):
        return True

    def get_wieght(self):
        return self.wieght

    def get_value(self):
        return self.value


class IntlNode(HuffNode):

    def __init__(self, left_child=None, right_child=None):
        super(IntlNode, self).__init__()
        # 节点的值
        self.wieght = left_child.get_wieght() + right_child.get_wieght()
        # 节点的左右子节点
        self.left_child = left_child
        self.right_child = right_child

    def isleaf(self):
        return False

    def get_wieght(self):
        return self.wieght

    def get_left(self):
        return self.left_child

    def get_right(self):
        return self.right_child


class HuffTree(object):

    def __init__(self, flag, value=0, freq=0, left_tree=None, right_tree=None):

        super(HuffTree, self).__init__()

        if flag == 0:
            self.root = LeafNode(value, freq)
        else:
            self.root = IntlNode(left_tree.get_root(), right_tree.get_root())

    def get_root(self):
        return self.root

    def get_wieght(self):
        return self.root.get_wieght()

    def traverse_huffman_tree(self, root, code, char_freq):
        if root.isleaf():
            char_freq[root.get_value()] = code
            print(("it = %c  and  freq = %d  code = %s") % (chr(root.get_value()), root.get_wieght(), code))
            return None
        else:
            self.traverse_huffman_tree(root.get_left(), code + '0', char_freq)
            self.traverse_huffman_tree(root.get_right(), code + '1', char_freq)


def buildHuffmanTree(list_hufftrees):
    while len(list_hufftrees) > 1:                    #  按照weight 对huffman树进行从小到大的排序
        list_hufftrees.sort(key=lambda x: x.get_wieght())             # 2. 跳出weight 最小的两个huffman编码树
        temp1 = list_hufftrees[0]
        temp2 = list_hufftrees[1]
        list_hufftrees = list_hufftrees[2:]                     # 3. 构造一个新的huffman树
        newed_hufftree = HuffTree(1, 0, 0, temp1, temp2)          # 4. 放入到数组当中
        list_hufftrees.append(newed_hufftree)            # last.  数组中最后剩下来的那棵树，就是构造的Huffman编码树
    return list_hufftrees[0]


def compress():# 1. 以二进制的方式打开文件
    inputfilename=input.get()
    outputfilename=output.get()
    f = open(inputfilename, 'rb')
    filedata = f.read()            # 获取文件的字节总数
    filesize = f.tell()          # 2. 统计 byte的取值［0-255］ 的每个值出现的频率
    # 保存在字典 char_freq中
    char_freq = {}
    for x in range(filesize):
        tem = filedata[x]
        if tem in char_freq.keys():
            char_freq[tem] = char_freq[tem] + 1
        else:
            char_freq[tem] = 1

    # 输出统计结果
    for tem in char_freq.keys():
        print(tem, ' : ', char_freq[tem])

    # 3. 开始构造原始的huffman编码树数组，用于构造Huffman编码树
    list_hufftrees = []
    for x in char_freq.keys():
        # 使用 HuffTree的构造函数定义一棵只包含一个叶节点的Huffman树
        tem = HuffTree(0, x, char_freq[x], None, None)
        # 将其添加到数组 list_hufftrees 当中
        list_hufftrees.append(tem)

    # 4. 步骤2中获取到的每个值出现的频率的信息
    # 4.1. 保存叶节点的个数
    length = len(char_freq.keys())
    output = open(outputfilename, 'wb')

    # 一个int型的数有四个字节，所以将其分成四个字节写入到输出文件当中
    a4 = length & 255
    length = length >> 8
    a3 = length & 255
    length = length >> 8
    a2 = length & 255
    length = length >> 8
    a1 = length & 255
    output.write(six.int2byte(a1))
    output.write(six.int2byte(a2))
    output.write(six.int2byte(a3))
    output.write(six.int2byte(a4))

    # 4.2  每个值及其出现的频率的信息
    # 遍历字典 char_freq
    for x in char_freq.keys():
        output.write(six.int2byte(x))
        temp = char_freq[x]
        # 同样出现的次数是int型，分成四个字节写入到压缩文件当中
        a4 = temp & 255
        temp = temp >> 8
        a3 = temp & 255
        temp = temp >> 8
        a2 = temp & 255
        temp = temp >> 8
        a1 = temp & 255
        output.write(six.int2byte(a1))
        output.write(six.int2byte(a2))
        output.write(six.int2byte(a3))
        output.write(six.int2byte(a4))

    # 5. 构造huffman编码树，并且获取到每个字符对应的编码
    tem = buildHuffmanTree(list_hufftrees)
    tem.traverse_huffman_tree(tem.get_root(), '', char_freq)

    # 6. 开始对文件进行压缩
    code = ''
    for i in range(filesize):
        key = filedata[i]  
        code = code + char_freq[key]
        out = 0
        while len(code) > 8:
            for x in range(8):
                out = out << 1
                if code[x] == '1':
                    out = out | 1
            code = code[8:]
            output.write(six.int2byte(out))
            out = 0

    # 处理剩下来的不满8位的code
    output.write(six.int2byte(len(code)))
    out = 0
    for i in range(len(code)):
        out = out << 1
        if code[i] == '1':
            out = out | 1
    for i in range(8 - len(code)):
        out = out << 1
    # 把最后一位给写入到文件当中
    output.write(six.int2byte(out))

    # 6.关闭输出文件，文件压缩完毕
    output.close()


def decompress():   # 读取文件
    inputfilename=input.get()
    outputfilename=output.get()
    f = open(inputfilename, 'rb')
    filedata = f.read()
    # 获取文件的字节总数
    filesize = f.tell()

    a1 = filedata[0]
    a2 = filedata[1]
    a3 = filedata[2]
    a4 = filedata[3]
    j = 0
    j = j | a1
    j = j << 8
    j = j | a2
    j = j << 8
    j = j | a3
    j = j << 8
    j = j | a4

    leaf_node_size = j

    # 2. 读取压缩文件中保存的相信的原文件中 ［0-255］出现的频率的信息
    # 构造一个字典 char_freq 一遍重建 Huffman编码树
    char_freq = {}
    for i in range(leaf_node_size):
        c = filedata[4 + i * 5 + 0]  
        a1 = filedata[4 + i * 5 + 1]
        a2 = filedata[4 + i * 5 + 2]
        a3 = filedata[4 + i * 5 + 3]
        a4 = filedata[4 + i * 5 + 4]
        j = 0
        j = j | a1
        j = j << 8
        j = j | a2
        j = j << 8
        j = j | a3
        j = j << 8
        j = j | a4
        print(c, j)
        char_freq[c] = j

    # 3. 重建huffman 编码树，和压缩文件中建立Huffman编码树的方法一致
    list_hufftrees = []
    for x in char_freq.keys():
        tem = HuffTree(0, x, char_freq[x], None, None)
        list_hufftrees.append(tem)
    tem = buildHuffmanTree(list_hufftrees)
    tem.traverse_huffman_tree(tem.get_root(), '', char_freq)

    # 4. 使用步骤3中重建的huffman编码树，对压缩文件进行解压缩
    output = open(outputfilename, 'wb')
    code = ''
    currnode = tem.get_root()
    for x in range(leaf_node_size * 5 + 4, filesize):
        # python3
        c = filedata[x]
        for i in range(8):
            if c & 128:
                code = code + '1'
            else:
                code = code + '0'
            c = c << 1

        while len(code) > 24:
            if currnode.isleaf():
                tem_byte = six.int2byte(currnode.get_value())
                output.write(tem_byte)
                currnode = tem.get_root()

            if code[0] == '1':
                currnode = currnode.get_right()
            else:
                currnode = currnode.get_left()
            code = code[1:]

    # 4.1 处理最后 24位
    sub_code = code[-16:-8]
    last_length = 0
    for i in range(8):
        last_length = last_length << 1
        if sub_code[i] == '1':
            last_length = last_length | 1

    code = code[:-16] + code[-8:-8 + last_length]

    while len(code) > 0:
        if currnode.isleaf():
            tem_byte = six.int2byte(currnode.get_value())
            output.write(tem_byte)
            currnode = tem.get_root()
        if code[0] == '1':
            currnode = currnode.get_right()
        else:
            currnode = currnode.get_left()
        code = code[1:]
    if currnode.isleaf():
        tem_byte = six.int2byte(currnode.get_value())
        output.write(tem_byte)
        currnode = tem.get_root()

    # 4. 关闭文件，解压缩完毕
    output.close()

tk.Label(window,text='input filename',font=('Arial',16),fg='black',bg='white').place(x=100,y=100)
tk.Label(window,text='output filename',font=('Arial',16),fg='black',bg='white').place(x=300,y=100)

input=tk.StringVar()
entry=tk.Entry(window,textvariable=input,font=('Arial',16),width=8,show=None).place(x=100,y=130)

output=tk.StringVar()
entry=tk.Entry(window,textvariable=output,font=('Arial',16),width=8,show=None).place(x=300,y=130)

ch1=tk.Button(window,text='compress',command=compress,width=8).place(x=100,y=300)
ch2=tk.Button(window,text='decompress',command=decompress,width=8).place(x=300,y=300)
window.mainloop()


"""if __name__ == '__main__':
    # 1. 获取用户的输入
    # FLAG 0 代表压缩文件 1代表解压缩文件
    # INPUTFILE： 输入的文件名
    # OUTPUTFILE：输出的文件名
    if len(sys.argv) != 4:
        print("please input the filename!!!")
        exit(0)
    else:
        FLAG = sys.argv[1]
        INPUTFILE = sys.argv[2]
        OUTPUTFILE = sys.argv[3]

    # 压缩文件
    if FLAG == '0':
        print('compress file')
        compress(INPUTFILE, OUTPUTFILE)
    # 解压缩文件
    else:
        print('decompress file')
        decompress(INPUTFILE, OUTPUTFILE)
"""
